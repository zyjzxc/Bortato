extends "res://entities//units//player//player.gd"

const MYMOD_LOG = "Jay-Bortato" # ! Change `MODNAME` to your actual mod's name


var value_safely_moving_boosted = {}
const _accum_keys = [
		["accum_explosion_size", "explosion_size"],
		[ "accum_speed", "stat_speed"]
		]

var _not_auto_tmp_stats = ["percent_materials"]

# Called when the node enters the scene tree for the first time.
func _init():
	for keys in _accum_keys:
		_not_auto_tmp_stats.append(keys[0])
	
func _on_MovingTimer_timeout()->void :
	._on_MovingTimer_timeout()
	handle_timer_stat("temp_stats_while_moving")

func handle_timer_stat(effect_key:String)->void :
	for temp_stat in RunData.effects[effect_key]:
		for keys in _accum_keys:
			var accum_key = keys[0]
			var stat_key = keys[1]
			if temp_stat[0] == accum_key:
				if not value_safely_moving_boosted.has(stat_key):
					value_safely_moving_boosted[stat_key] = 0
				value_safely_moving_boosted[stat_key] += temp_stat[1]
				TempStats.add_stat(stat_key, temp_stat[1])


func check_not_moving_stats(movement:Vector2)->void :
	.check_not_moving_stats(movement)
#	if (movement.x == 0 and movement.y == 0):
#		_remove_safely_moving_bonus()

func check_moving_stats(movement:Vector2)->void :
	
	if not moving_bonuses_applied and RunData.effects["temp_stats_while_moving"].size() > 0 and (movement.x != 0 or movement.y != 0):
		moving_bonuses_applied = true
		
		_moving_timer.start()
		
		for temp_stat_while_moving in RunData.effects["temp_stats_while_moving"]:
			if not _not_auto_tmp_stats.has(temp_stat_while_moving[0]):
				TempStats.add_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
		
		reset_weapons_cd()
	elif moving_bonuses_applied and movement.x == 0 and movement.y == 0:
		moving_bonuses_applied = false
		
		_moving_timer.stop()
		
		for temp_stat_while_moving in RunData.effects["temp_stats_while_moving"]:
			if not _not_auto_tmp_stats.has(temp_stat_while_moving[0]):
				TempStats.remove_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
		
		reset_weapons_cd()

func _remove_safely_moving_bonus()->void:
	for keys in _accum_keys:
		var stat_key = keys[1]
		if value_safely_moving_boosted.has(stat_key) and value_safely_moving_boosted[stat_key] != 0:
			TempStats.remove_stat(stat_key, value_safely_moving_boosted[stat_key])
			value_safely_moving_boosted[stat_key] = 0

func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
	# var dmg_taken = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale, bypass_invincibility)
	var dmg_taken = [0, 0]
	if hitbox and hitbox.is_healing:
		var _healed = on_healing_effect(value)
	elif _invincibility_timer.is_stopped() or bypass_invincibility:
		dmg_taken = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale)
		
		
		if dmg_taken[2]:
			if RunData.effects["dmg_on_dodge"].size() > 0 and hitbox != null and hitbox.from != null and is_instance_valid(hitbox.from):
				var total_dmg_to_deal = 0
				for dmg_on_dodge in RunData.effects["dmg_on_dodge"]:
					if randf() >= dmg_on_dodge[2] / 100.0:
						continue
					var dmg_from_stat = max(1, (dmg_on_dodge[1] / 100.0) * Utils.get_stat(dmg_on_dodge[0]))
					var dmg = RunData.get_dmg(dmg_from_stat) as int
					total_dmg_to_deal += dmg
				var dmg_dealt = hitbox.from.take_damage(total_dmg_to_deal)
				RunData.tracked_item_effects["item_riposte"] += dmg_dealt[1]
			
			if RunData.effects["heal_on_dodge"].size() > 0:
				var total_to_heal = 0
				for heal_on_dodge in RunData.effects["heal_on_dodge"]:
					if randf() < heal_on_dodge[2] / 100.0:
						total_to_heal += heal_on_dodge[1]
				var _healed = on_healing_effect(total_to_heal, "item_adrenaline", false)
		
		if dmg_taken[1] > 0 and consumables_in_range.size() > 0:
			for cons in consumables_in_range:
				cons.attracted_by = self
		
		if dodgeable:
			disable_hurtbox()
			_invincibility_timer.start(get_iframes(dmg_taken[1]))
		
		if dmg_taken[1] > 0:
			if RunData.effects["explode_on_hit"].size() > 0:
				var effect = RunData.effects["explode_on_hit"][0]
				var stats = _explode_on_hit_stats
				var _inst = WeaponService.explode(effect, global_position, stats.damage, stats.accuracy, stats.crit_chance, stats.crit_damage, stats.burning_data)
			
			if RunData.effects["temp_stats_on_hit"].size() > 0:
				for temp_stat_on_hit in RunData.effects["temp_stats_on_hit"]:
					TempStats.add_stat(temp_stat_on_hit[0], temp_stat_on_hit[1])
			
			check_hp_regen()
		
		# return dmg_taken

	if dmg_taken[1] > 0:
		_remove_safely_moving_bonus()
	return dmg_taken

