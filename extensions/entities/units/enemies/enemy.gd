extends "res://entities/units/enemies/enemy.gd"



func _on_Hurtbox_area_entered(hitbox:Area2D)->void :
	# if RunData.effects["blade_storm"].size() > 0:
	# 	var dir = global_position - hitbox.global_position
	# 	var rot = Vector2(cos(hitbox.global_rotation), sin(hitbox.global_rotation))
	# 	var dis = (TempStats.player.global_position - global_position).length()
	# 	if dis > 50 and dir.dot(rot) < 0:
	# 		ModLoaderUtils.log_info("length %f %d" % [dis, hitbox.get_instance_id()], "Jay2")
	# 		return
	._on_Hurtbox_area_entered(hitbox)

#func _physics_process(delta):
#	_hitbox.enable()
