extends ExplodingEffect


static func get_id()->String:
	return "character_exploding_effect"

func apply()->void :
	RunData.effects[key].push_back(self)


func unapply()->void :
	RunData.effects[key].erase(self)
