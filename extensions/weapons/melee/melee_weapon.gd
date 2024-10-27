extends "res://weapons/melee/melee_weapon.gd"


var is_blade_storm:bool

onready var _collision:CollisionShape2D = $Sprite / Hitbox / Collision

func _ready()->void :
	if RunData.get_player_effect("blade_storm", player_index).size() > 0:
		is_blade_storm = true
#		if not RunData.players_data[player_index].bladestorm_weapon_changed.has(weapon_id) or not RunData.players_datap[player_index].bladestorm_weapon_changed[weapon_id]:
#			_collision.shape.extents.x *= 0.5
#			RunData.bladestorm_weapon_changed[weapon_id] = true
#		var offest = _collision.shape.extents.x * 0.5
#		_collision.position.x *= 0.5
#		_collision.position.x += offest
#	else:
#		# Restores the modified weapon properties
#		if RunData.players_data[player_index].bladestorm_weapon_changed.has(weapon_id) and RunData.players_datap[player_index].bladestorm_weapon_changed[weapon_id]:
#			_collision.shape.extents.x *= 2
#			RunData.players_datap[player_index].bladestorm_weapon_changed[weapon_id] = false

	._ready()

func init_stats(at_wave_begin:bool = true)->void :
	.init_stats(at_wave_begin)
	if not at_wave_begin:
		_current_cooldown = min(_current_cooldown, current_stats.cooldown)


func update_sprite_flipv()->void :
	if is_blade_storm:
		return
	.update_sprite_flipv()
	
func update_idle_angle()->void :
	if is_blade_storm:
		_current_idle_angle = _idle_angle
		return
	.update_idle_angle()

func get_direction()->float:
	if is_blade_storm:
		return _current_idle_angle
	return .get_direction()


func get_direction_and_calculate_target()->float:
	if is_blade_storm:
		return _current_idle_angle
	return .get_direction_and_calculate_target()

func shoot()->void :
	if not is_blade_storm:
		.shoot()
		return
	

func _on_Hitbox_area_entered(area):
	if area.get_parent().name.count("EnemyProjectile"):
		area.get_parent().set_to_be_destroyed()
