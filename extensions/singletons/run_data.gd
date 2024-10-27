extends "res://singletons//run_data.gd"

func _init():
	effect_keys_full_serialization.push_back("explode_on_hit_ex")

func init_elites_spawn(base_wave:int = 10, horde_chance:float = 0.4)->void :
	for player_index in get_player_count():
		var current_character = get_player_character(player_index)
		if current_character != null and (current_character.my_id == "character_jack" or current_character.my_id == "character_gangster" or "_jay_" in current_character.my_id):
			horde_chance = 0.0
	.init_elites_spawn(base_wave, horde_chance)
