extends Effect



static func get_id()->String:
	return "custom_key"


func apply()->void :
	RunData.effects[custom_key].push_back(value)


func unapply()->void :
	RunData.effects[custom_key].erase(value)



