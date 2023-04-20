extends "res://singletons//run_data.gd"

func init_elites_spawn(base_wave:int = 10, horde_chance:float = 0.4)->void :
	elites_spawn = []
	var diff = get_current_difficulty()
	var nb_elites = 0
	var possible_elites = ItemService.elites.duplicate()
	
	if current_character != null and ["character_jack", "character_rock"].has(current_character.my_id):# == "character_jack":
		horde_chance = 0.0
	
	if diff < 2:
		return 
	elif diff < 4:
		nb_elites = 1
	else :
		nb_elites = 3
	
	var wave = Utils.get_random_int(base_wave + 1, base_wave + 2)
	
	for i in nb_elites:
		
		var type = EliteType.HORDE if randf() < horde_chance else EliteType.ELITE
		
		if i == 1:
			if current_character.my_id == "character_rock":
				wave = 15
			else:
				wave = Utils.get_random_int(base_wave + 4, base_wave + 5)
		elif i == 2:
			wave = Utils.get_random_int(base_wave + 7, base_wave + 8)
			type = EliteType.ELITE
		
		var elite_id = Utils.get_rand_element(possible_elites).my_id if type == EliteType.ELITE else ""
		
		for elite in possible_elites:
			if elite.my_id == elite_id:
				possible_elites.erase(elite)
				break
		
		elites_spawn.push_back([wave, type, elite_id])
