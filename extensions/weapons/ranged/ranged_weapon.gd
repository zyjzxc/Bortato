extends "res://weapons/ranged/ranged_weapon.gd"


func init_stats(at_wave_begin:bool = true)->void :
	.init_stats(at_wave_begin)
	if not at_wave_begin:
		_current_cooldown = min(_current_cooldown, current_stats.cooldown)
