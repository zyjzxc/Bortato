extends "res://entities//units//player//player.gd"

const MYMOD_LOG = "Jay-Rock" # ! Change `MODNAME` to your actual mod's name


var value_safely_moving_boosted = {}

var value_buff_boosted = {}

var _not_auto_tmp_stats = ["percent_materials"]

var _storm_duration = 0

var _weapon_enabled = 0

var _explode_on_hit_ex_stats = null

func _ready():
	if RunData.effects["explode_on_hit_ex"].size() > 0:
		init_exploding_ex_stats()
	if RunData.effects["lose_accum_hp_per_second"].size() > 0:
		_lose_health_timer.start()

func update_player_stats()->void :
	.update_player_stats()
	if RunData.effects["explode_on_hit_ex"].size() > 0:
		init_exploding_ex_stats()

func _on_LoseHealthTimer_timeout()->void :
	if RunData.effects["lose_hp_per_second"] > 0:
		var _dmg_taken = take_damage(RunData.effects["lose_hp_per_second"], null, false, false, null, 1.0, true)
	if RunData.effects["lose_accum_hp_per_second"].size() > 0:
		for effect in RunData.effects["lose_accum_hp_per_second"]:
			var _dmg_taken = take_damage(min(effect[1] * RunData.current_wave, effect[2]), null, false, false, null, 1.0, true)


func _is_special_tmp_status(stat:String)->bool:
	return _not_auto_tmp_stats.has(stat) or stat.begins_with("running_accum_")

func _on_MovingTimer_timeout()->void :
	._on_MovingTimer_timeout()
	handle_moving_timer_stat("temp_stats_while_moving")

func handle_moving_timer_stat(effect_key:String)->void :
	for temp_stat in RunData.effects[effect_key]:
		if temp_stat[0].begins_with("running_accum_"):
			var stat_key = temp_stat[0]
			stat_key.erase(0, "running_accum_".length())
			if not value_safely_moving_boosted.has(stat_key):
				value_safely_moving_boosted[stat_key] = 0
			value_safely_moving_boosted[stat_key] += temp_stat[1]
			TempStats.add_stat(stat_key, temp_stat[1])
			TempStats.emit_updated()

func check_moving_stats(movement:Vector2)->void :
	if not moving_bonuses_applied and RunData.effects["temp_stats_while_moving"].size() > 0 and (movement.x != 0 or movement.y != 0):
		moving_bonuses_applied = true
		
		_moving_timer.start()
		
		for temp_stat_while_moving in RunData.effects["temp_stats_while_moving"]:
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.add_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
				TempStats.emit_updated()
		
		reset_weapons_cd()
	elif moving_bonuses_applied and movement.x == 0 and movement.y == 0:
		moving_bonuses_applied = false
		
		_moving_timer.stop()
		
		for temp_stat_while_moving in RunData.effects["temp_stats_while_moving"]:
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.remove_stat(temp_stat_while_moving[0], temp_stat_while_moving[1])
				TempStats.emit_updated()
		
		reset_weapons_cd()

func _remove_safely_moving_bonus()->void:
	for stat_key in value_safely_moving_boosted:
		if value_safely_moving_boosted[stat_key] != 0:
			TempStats.remove_stat(stat_key, value_safely_moving_boosted[stat_key])
			value_safely_moving_boosted[stat_key] = 0
			TempStats.emit_updated()

func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
	var dmg_taken = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale, bypass_invincibility)
	# modified by jay
	if dmg_taken[1] > 0:
		if RunData.effects["explode_on_hit_ex"].size() > 0:
			var effect = RunData.effects["explode_on_hit_ex"][0]
			var stats = _explode_on_hit_ex_stats
			var _inst = WeaponService.explode(effect, global_position, stats.damage, stats.accuracy, stats.crit_chance, stats.crit_damage, stats.burning_data)
		_remove_safely_moving_bonus()
	return dmg_taken
	
func init_exploding_ex_stats()->void :
	_explode_on_hit_ex_stats = WeaponService.init_base_stats(RunData.effects["explode_on_hit_ex"][0].stats, "", [], [ExplodingEffect.new()])

func _physics_process(delta)->void :

	if RunData.effects["blade_storm"].size() > 0 and current_weapons.size() > 0:
		_storm_duration = 0.0
		for weapon in current_weapons:
			_storm_duration += weapon.current_stats.cooldown
		_storm_duration *= max( 0.1, current_stats.health * 1.0 / max_stats.health) * 0.07 / current_weapons.size()
		_storm_duration = max(_storm_duration, 0.04)
		_weapons_container.rotation += delta / _storm_duration * TAU
		
		for weapon in current_weapons:
			if _weapons_container.rotation > TAU:
				weapon.disable_hitbox()
				weapon.enable_hitbox()
			weapon._hitbox.set_knockback( - Vector2(cos(weapon.global_rotation), sin(weapon.global_rotation)), weapon.current_stats.knockback)
		
		if _weapons_container.rotation > TAU:
				_weapons_container.rotation -= TAU
	for stat in value_buff_boosted:
		var idx_remove = []
		for idx in value_buff_boosted[stat].size():
			value_buff_boosted[stat][idx][1] -= delta
			if value_buff_boosted[stat][idx][1] <= 0:
				idx_remove.push_back(idx)
		idx_remove.invert()
		for i in idx_remove:
			TempStats.remove_stat(stat, value_buff_boosted[stat][i][0])
			value_buff_boosted[stat].remove(i)
			TempStats.emit_updated()

#func _on_ItemAttractArea_area_entered(area:Area2D)->void :
#	var is_heal = area is Consumable
#
#	if is_heal and current_stats.health >= max_stats.health:
#		consumables_in_range.push_back(area)
#	elif not is_heal or (is_heal and current_stats.health < max_stats.health):
#		area.attracted_by = self
				
func on_buff_effect(stat:String, value:int, last:int)->void:
	if not stat in value_buff_boosted:
		value_buff_boosted[stat] = []
	value_buff_boosted[stat].push_back([value, last])
	TempStats.add_stat(stat, value)
	TempStats.emit_updated()
