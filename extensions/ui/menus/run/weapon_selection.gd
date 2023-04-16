extends "res://ui//menus//run//weapon_selection.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_element_pressed(element:InventoryElement)->void :
	if weapon_added:
		return 
	
	if element.is_random:
		weapon_added = true
		var _weapon = RunData.add_weapon(Utils.get_rand_element(available_elements), true)
	elif element.is_special:
		return 
	else :
		weapon_added = true
		var _weapon = RunData.add_weapon(element.item, true)

	# called in character_selection to fix rock can't get starts item problem.
	# RunData.add_starting_items_and_weapons()
	
	var _error = get_tree().change_scene(MenuData.difficulty_selection_scene)
