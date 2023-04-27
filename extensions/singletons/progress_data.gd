extends "res://singletons/progress_data.gd"


func is_manual_aim()->bool:
	if RunData.effects["blade_storm"].size() > 0:
		return false
	return .is_manual_aim()
