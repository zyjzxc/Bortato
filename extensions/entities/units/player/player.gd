extends "res://entities//units//player//player.gd"

const MYMOD_LOG = "Jay-Rock" # ! Change `MODNAME` to your actual mod's name


var value_safely_moving_boosted = {}

var _not_auto_tmp_stats = ["percent_materials"]

var _storm_duration = 0

var _weapon_enabled = 0


func _is_special_tmp_status(stat:String)->bool:
	return _not_auto_tmp_stats.has(stat) or stat.begins_with("accum_")

func _on_MovingTimer_timeout()->void :
	._on_MovingTimer_timeout()
	handle_timer_stat("temp_stats_while_moving")

func handle_timer_stat(effect_key:String)->void :
	for temp_stat in RunData.effects[effect_key]:
		if temp_stat[0].begins_with("accum_"):
			var stat_key = temp_stat[0]
			stat_key.erase(0, 6)
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
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.add_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
		
		reset_weapons_cd()
	elif moving_bonuses_applied and movement.x == 0 and movement.y == 0:
		moving_bonuses_applied = false
		
		_moving_timer.stop()
		
		for temp_stat_while_moving in RunData.effects["temp_stats_while_moving"]:
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.remove_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
		
		reset_weapons_cd()

func _remove_safely_moving_bonus()->void:
	for stat_key in value_safely_moving_boosted:
		if value_safely_moving_boosted[stat_key] != 0:
			TempStats.remove_stat(stat_key, value_safely_moving_boosted[stat_key])
			value_safely_moving_boosted[stat_key] = 0

func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
	var dmg_taken = [0, 0]
	if hitbox and hitbox.is_healing:
		var _healed = on_healing_effect(value)
	elif _invincibility_timer.is_stopped() or bypass_invincibility:
		dmg_taken = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale)
		
		
		if dmg_taken.size() > 2 and dmg_taken[2]:
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
	# modified by jay
	if dmg_taken[1] > 0:
		_remove_safely_moving_bonus()
	return dmg_taken

func _physics_process(delta)->void :

	if RunData.effects["blade_storm"].size() > 0 and current_weapons.size() > 0:
		_storm_duration = 0.0
		for weapon in current_weapons:
			_storm_duration += weapon.current_stats.cooldown
		_storm_duration *= max( 0.1, current_stats.health * 1.0 / max_stats.health) * 0.07 / current_weapons.size()
		_storm_duration = max(_storm_duration, 0.017)
		_weapons_container.rotation += delta / _storm_duration * TAU
		
		for weapon in current_weapons:
			if _weapons_container.rotation > TAU:
				weapon.disable_hitbox()
				weapon.enable_hitbox()
			weapon._hitbox.set_knockback( - Vector2(cos(weapon.global_rotation), sin(weapon.global_rotation)), weapon.current_stats.knockback)
		
		if _weapons_container.rotation > TAU:
				_weapons_container.rotation -= TAU
