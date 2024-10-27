extends "res://singletons//player_run_data.gd"

var bladestorm_weapon_changed = {}

signal buff_effect(stat, value, last)

static func init_effects()->Dictionary:
	var all_effects = .init_effects()
	all_effects["explosion_eliminate_bullets"] = []
	all_effects["blade_storm"] = []
	all_effects["split_bullet"] = []
	all_effects["heal_on_kill"] = 0
	all_effects["lose_accum_hp_per_second"] = []
	all_effects["buff_pick_up_consumable"] = []
	all_effects["explode_on_hit_ex"] = []
	return all_effects
