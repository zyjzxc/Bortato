extends "res://singletons//weapon_service.gd"


func explode(effect:Effect, pos:Vector2, damage:int, accuracy:float, crit_chance:float, crit_dmg:float, burning_data:BurningData, is_healing:bool = false, ignored_objects:Array = [], damage_tracking_key:String = "")->Node:
	var main = get_tree().current_scene
	var instance = effect.explosion_scene.instance()
	instance.set_deferred("global_position", pos)
	main.call_deferred("add_child", instance)
	instance.set_deferred("sound_db_mod", effect.sound_db_mod)
	instance.call_deferred("set_damage_tracking_key", damage_tracking_key)
	instance.call_deferred("set_damage", damage, accuracy, crit_chance, crit_dmg, burning_data, is_healing, ignored_objects)
	instance.call_deferred("set_smoke_amount", round(effect.scale * effect.base_smoke_amount))
	# modified by jay
	# pre calculate area. 
	var explosion_scale = max(0.1, effect.scale + (effect.scale * (Utils.get_stat("explosion_size") / 100.0)))
	instance.call_deferred("set_area", explosion_scale)
	return instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_ranged_stats(from_stats:RangedWeaponStats = RangedWeaponStats.new(), weapon_id:String = "", sets:Array = [], effects:Array = [], is_structure:bool = false)->RangedWeaponStats:
	var new_stats =.init_ranged_stats(from_stats, weapon_id, sets, effects, is_structure)
	if RunData.effects["split_bullet"].size() > 0 and weapon_id != "":
		new_stats.nb_projectiles *= 3
		new_stats.projectile_spread = 0.5 if new_stats.nb_projectiles <= 3 else 1.0
		new_stats.damage *= 0.5
	if RunData.effects["explosive_weapon"].size() > 0 and weapon_id != "":
		var effect = RunData.effects["explosive_weapon"][0]
		if effect.ranged_effect == null:
			var ranged_effect = ExplodingEffect.new()
			ranged_effect.chance = effect.chance * 2
			ranged_effect.explosion_scene = effect.explosion_scene
			ranged_effect.base_smoke_amount = effect.base_smoke_amount
			ranged_effect.sound_db_mod = effect.sound_db_mod
			ranged_effect.scale = effect.scale
			ranged_effect.key = "effect_explode_custom"
			effect.ranged_effect = ranged_effect
		if not effects.has(effect.ranged_effect):
			effects.append(effect.ranged_effect)
	return new_stats

func init_melee_stats(from_stats:MeleeWeaponStats = MeleeWeaponStats.new(), weapon_id:String = "", sets:Array = [], effects:Array = [], is_structure:bool = false)->MeleeWeaponStats:
	var new_stats =.init_melee_stats(from_stats, weapon_id, sets, effects, is_structure)
	if RunData.effects["explosive_weapon"].size() > 0 and weapon_id != "":
		var effect = RunData.effects["explosive_weapon"][0]
		if effect.melee_effect == null:
			var melee_effect = ExplodingEffect.new()
			melee_effect.chance = effect.chance
			melee_effect.explosion_scene = effect.explosion_scene
			melee_effect.base_smoke_amount = effect.base_smoke_amount
			melee_effect.sound_db_mod = effect.sound_db_mod
			melee_effect.scale = effect.scale
			melee_effect.key = "effect_explode_melee"
			effect.melee_effect = melee_effect
		if not effects.has(effect.melee_effect):
			effects.append(effect.melee_effect)
	return new_stats
	
