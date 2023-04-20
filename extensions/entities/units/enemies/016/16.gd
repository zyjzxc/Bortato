extends "res://entities/units/enemies/016/16.gd"


func die(knockback_vector:Vector2 = Vector2.ZERO, p_cleaning_up:bool = false)->void :
	.die(knockback_vector, p_cleaning_up)
	
	if p_cleaning_up:
		return 
	var spawn_num = 3
	if RunData.effects.has("enemy_spawn_num"):
		spawn_num = RunData.effects["enemy_spawn_num"]
	for i in spawn_num:
		emit_signal("wanted_to_spawn_an_enemy", enemy_to_spawn, ZoneService.get_rand_pos_in_area(Vector2(global_position.x, global_position.y), 200))
