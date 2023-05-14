extends "res://main.gd"

# Brief overview of what the changes in this file do...

const MYMOD_LOG = "Jay-Rock" # ! Change `MODNAME` to your actual mod's name

var dir = ""

var _consumables_pickde_this_wave = 0

# Extensions
# =============================================================================

func _ready()->void:
	# ! Note that we're *not* calling `.return` here. This is because, unlike
	# ! all other vanilla funcs (eg `get_gold_bag_pos` below), _ready will
	# ! always fire, regardless of your code. In all other cases, we would still
	# ! need to call it

	# ! Note that you won't see this in the log immediately, because main.gd
	# ! doesn't run until you start a run
	ModLoaderUtils.log_info("Ready", MYMOD_LOG)
	dir = ModLoader.UNPACKED_DIR + MYMOD_LOG
	# ! These are custom functions. It will run after vanilla's own _ready is
	# ! finished
	_modname_my_custom_edit_2()


func _on_EntitySpawner_player_spawned(player:Player)->void :
	._on_EntitySpawner_player_spawned(player)
	var _error_buff_effect = RunData.connect("buff_effect", player, "on_buff_effect")

func on_consumable_picked_up(consumable:Node)->void :
	.on_consumable_picked_up(consumable)
	if not _cleaning_up and RunData.effects["buff_pick_up_consumable"].size() > 0:
		_consumables_pickde_this_wave += 1
		for effect in RunData.effects["buff_pick_up_consumable"]:
			var value = max(1, effect[1] / _consumables_pickde_this_wave)
			RunData.emit_signal("buff_effect", effect[0], effect[1], effect[2])


# Custom
# =============================================================================

func _modname_my_custom_edit_2()->void:
	ModLoaderUtils.log_info("Main.gd has been modified", MYMOD_LOG)
