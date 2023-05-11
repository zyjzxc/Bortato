extends ExplodingEffect

var melee_effect
var ranged_effect

func _ready():
	melee_effect = ExplodingEffect.new()
	melee_effect.chance = chance
	melee_effect.explosion_scene = explosion_scene
	melee_effect.scale = scale
	melee_effect.base_smoke_amount = base_smoke_amount
	melee_effect.sound_db_mod = sound_db_mod

static func get_id()->String:
	return "character_exploding_effect"

func apply()->void :
	RunData.effects[key].push_back(self)


func unapply()->void :
	RunData.effects[key].erase(self)
