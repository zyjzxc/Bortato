extends "res://weapons/weapon.gd"


var is_blade_storm:bool

onready var _collision:CollisionShape2D = $Sprite / Hitbox / Collision

func _ready()->void :
	if RunData.effects["blade_storm"].size() > 0:
		is_blade_storm = true
		if not RunData.bladestorm_weapon_changed.has(weapon_id) or not RunData.bladestorm_weapon_changed[weapon_id]:
			_collision.shape.extents.x *= 0.5
			RunData.bladestorm_weapon_changed[weapon_id] = true
		var offest = _collision.shape.extents.x * 0.5
		_collision.position.x *= 0.5
		_collision.position.x += offest

#		_hitbox.monitoring = true
#		_hitbox.collision_mask = 0b10000
#		_hitbox.connect("area_entered",self,"_on_Hitbox_area_entered")
	else:
		if RunData.bladestorm_weapon_changed.has(weapon_id) and RunData.bladestorm_weapon_changed[weapon_id]:
			_collision.shape.extents.x *= 2
			RunData.bladestorm_weapon_changed[weapon_id] = false

	._ready()

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
