extends "res://weapons/weapon.gd"


var is_blade_storm:bool

func _ready()->void :
	if RunData.effects["blade_storm"].size() > 0:
		is_blade_storm = true
		.enable_hitbox()
		return
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
	

#func _physics_process(delta:float)->void :
#	if is_blade_storm:
#		return
#	._physics_process(delta)
