extends "res://entities//units//enemies//enemy.gd"


func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0)->Array:
	var dmg_taken = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale)
	if current_stats.health <= 0:
		if RunData.effects["heal_on_kill"] > 0:
			RunData.emit_signal("healing_effect", 1)
	return dmg_taken
