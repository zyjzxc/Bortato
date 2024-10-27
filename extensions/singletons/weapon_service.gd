extends "res://singletons//weapon_service.gd"


func explode(effect:Effect, args:WeaponServiceExplodeArgs)->Node:
#	# modified by jay
#	# pre calculate area. 
	var instance = .explode(effect, args)
	var explosion_scale = max(0.1, effect.scale + (effect.scale * (Utils.get_stat("explosion_size", args.from_player_index) / 100.0)))
	instance.call_deferred("set_area", explosion_scale)
	return instance


func init_ranged_stats(from_stats:RangedWeaponStats, player_index:int, is_special_spawn: = false, args: = WeaponServiceInitStatsArgs.new())->RangedWeaponStats:
	var new_stats =.init_ranged_stats(from_stats, player_index, is_special_spawn, args)
	var weapon_id = args.weapon_id
	var effects = args.effects
	
	if RunData.get_player_effect("split_bullet", player_index).size() > 0 and weapon_id != "":
		new_stats.nb_projectiles *= 3
		new_stats.projectile_spread = 0.5 if new_stats.nb_projectiles <= 3 else 1.0
		new_stats.damage *= 0.5
	return new_stats
