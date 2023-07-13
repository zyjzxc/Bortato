extends "res://ui//menus//run//character_selection.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_element_pressed(element:InventoryElement)->void :
#	if character_added:
#		return
	.on_element_pressed(element)
	# fix rock can't get starts item problem.
	if RunData.current_character and RunData.current_character.starting_weapons.size() == 0:
		RunData.add_starting_items_and_weapons()
