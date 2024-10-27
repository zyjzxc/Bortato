extends "res://singletons/progress_data.gd"


func is_manual_aim(player_index:int)->bool:
	if RunData.get_player_effect("blade_storm", player_index).size() > 0:
		return false
	return .is_manual_aim(player_index)
