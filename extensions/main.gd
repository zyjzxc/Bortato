extends "res://main.gd"

# Brief overview of what the changes in this file do...

const MYMOD_LOG = "Jay-Rock" # ! Change `MODNAME` to your actual mod's name

var dir = ""

# Extensions
# =============================================================================

func _ready()->void:
	# ! Note that we're *not* calling `.return` here. This is because, unlike
	# ! all other vanilla funcs (eg `get_gold_bag_pos` below), _ready will
	# ! always fire, regardless of your code. In all other cases, we would still
	# ! need to call it

	# ! Note that you won't see this in the log immediately, because main.gd
	# ! doesn't run until you start a run
	ModLoaderLog.info("Ready", MYMOD_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMOD_LOG
	# ! These are custom functions. It will run after vanilla's own _ready is
	# ! finished
	_modname_my_custom_edit_2()

func on_consumable_picked_up(consumable:Node, player_index)->void :
	.on_consumable_picked_up(consumable, player_index)
	if not _cleaning_up and RunData.get_player_effect("buff_pick_up_consumable", player_index).size() > 0:
		for effect in RunData.get_player_effect("buff_pick_up_consumable", player_index):
			RunData.players_data[player_index].emit_signal("buff_effect", effect[0], effect[1], 2)


# Custom
# =============================================================================

func _modname_my_custom_edit_2()->void:
	ModLoaderLog.info("Main.gd has been modified", MYMOD_LOG)
