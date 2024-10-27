extends "res://entities//units//player//player.gd"

const MYMOD_LOG = "Jay-Rock" # ! Change `MODNAME` to your actual mod's name


var value_safely_moving_boosted = {}

var value_buff_boosted = {}

var _not_auto_tmp_stats = ["percent_materials"]

var _storm_duration = 0

var _weapon_enabled = 0

var _explode_on_hit_ex_stats = null

func _ready():
	if RunData.get_player_effect("buff_pick_up_consumable", player_index).size() > 0:
		RunData.players_data[player_index].connect("buff_effect", self, "on_buff_effect")
	if RunData.get_player_effect("explode_on_hit_ex", player_index).size() > 0:
		init_exploding_ex_stats()

func update_player_stats(reset_current_health: = false)->void :
	.update_player_stats(reset_current_health)
	if RunData.get_player_effect("explode_on_hit_ex", player_index).size() > 0:
		init_exploding_ex_stats()

func _is_special_tmp_status(stat:String)->bool:
	return _not_auto_tmp_stats.has(stat) or stat.begins_with("running_accum_")

func _on_MovingTimer_timeout()->void :
	._on_MovingTimer_timeout()
	handle_moving_timer_stat("temp_stats_while_moving")

func handle_moving_timer_stat(effect_key:String)->void :
	for temp_stat in RunData.get_player_effect(effect_key, player_index):
		if temp_stat[0].begins_with("running_accum_"):
			var stat_key = temp_stat[0]
			stat_key.erase(0, "running_accum_".length())
			if not value_safely_moving_boosted.has(stat_key):
				value_safely_moving_boosted[stat_key] = 0
			value_safely_moving_boosted[stat_key] += temp_stat[1]
			TempStats.add_stat(stat_key, temp_stat[1], player_index)
	RunData.emit_stats_updated()

func check_moving_stats(movement:Vector2)->void :
	if not moving_bonuses_applied and RunData.get_player_effect("temp_stats_while_moving", player_index).size() > 0 and (movement.x != 0 or movement.y != 0):
		moving_bonuses_applied = true
		
		_moving_timer.start()
		
		for temp_stat_while_moving in RunData.get_player_effect("temp_stats_while_moving", player_index):
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.add_stat(temp_stat_while_moving[0], temp_stat_while_moving[1], player_index)
		RunData.emit_stats_updated()
		
		reset_weapons_cd()
	elif moving_bonuses_applied and movement.x == 0 and movement.y == 0:
		moving_bonuses_applied = false
		
		_moving_timer.stop()
		
		for temp_stat_while_moving in RunData.get_player_effect("temp_stats_while_moving", player_index):
			if not _is_special_tmp_status(temp_stat_while_moving[0]):
				TempStats.remove_stat(temp_stat_while_moving[0], temp_stat_while_moving[1], player_index)
		RunData.emit_stats_updated()
		
		reset_weapons_cd()

func _remove_safely_moving_bonus()->void:
	for stat_key in value_safely_moving_boosted:
		if value_safely_moving_boosted[stat_key] != 0:
			TempStats.remove_stat(stat_key, value_safely_moving_boosted[stat_key], player_index)
			value_safely_moving_boosted[stat_key] = 0
	RunData.emit_stats_updated()

# func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
func take_damage(value:int, args:TakeDamageArgs)->Array:
	var dmg_taken = .take_damage(value, args)
	# modified by jay
	if dmg_taken[1] > 0:
		if RunData.get_player_effect("explode_on_hit_ex", player_index).size() > 0:
			var effect = RunData.get_player_effect("explode_on_hit_ex", player_index)[0]
			var stats = _explode_on_hit_ex_stats
			var explode_args: = WeaponServiceExplodeArgs.new()
			explode_args.pos = global_position
			explode_args.damage = stats.damage
			explode_args.accuracy = stats.accuracy
			explode_args.crit_chance = stats.crit_chance
			explode_args.crit_damage = stats.crit_damage
			explode_args.burning_data = stats.burning_data
			explode_args.from_player_index = player_index
			var _inst = WeaponService.explode(effect, explode_args)
		_remove_safely_moving_bonus()
	return dmg_taken
	
func init_exploding_ex_stats()->void :
	_explode_on_hit_ex_stats = WeaponService.init_base_stats(RunData.get_player_effect("explode_on_hit_ex", player_index)[0].stats, player_index)

func _physics_process(delta)->void :

	if RunData.get_player_effect("blade_storm", player_index).size() > 0 and current_weapons.size() > 0:
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
			weapon._hitbox.set_knockback(
				- Vector2(cos(weapon.global_rotation), sin(weapon.global_rotation)),
				weapon.current_stats.knockback,
				weapon.current_stats.knockback_piercing)
		
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
			TempStats.remove_stat(stat, value_buff_boosted[stat][i][0], player_index)
			value_buff_boosted[stat].remove(i)
	RunData.emit_stats_updated()
				
func on_buff_effect(stat:String, value:int, last:int)->void:
	if not stat in value_buff_boosted:
		value_buff_boosted[stat] = []
	value_buff_boosted[stat].push_back([value, last])
	TempStats.add_stat(stat, value, player_index)
	RunData.emit_stats_updated()
