extends "res://main.gd"

# Brief overview of what the changes in this file do...

const MYMOD_LOG = "Jay-Bortato" # ! Change `MODNAME` to your actual mod's name

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
	ModLoaderUtils.log_info("Ready", MYMOD_LOG)
	dir = ModLoader.UNPACKED_DIR + MYMOD_LOG
	# ! These are custom functions. It will run after vanilla's own _ready is
	# ! finished
	_modname_my_custom_edit_2()


# This is the name of a func in vanilla
func get_gold_bag_pos()->Vector2:
	# ! This calls vanilla's version of this func. The period (.) before the
	# func lets you call it without triggering an infinite loop. In this case,
	# we're calling the vanilla func to get the original value; then, we can
	# modify it to whatever we like
	var gold_bag_pos = .get_gold_bag_pos()

	# ! If a vanilla func returns something (just as this one returns a Vector2),
	# ! your modded funcs should also return something with the same type
	return gold_bag_pos


# Custom
# =============================================================================

func _modname_my_custom_edit_2()->void:
	ModLoaderUtils.log_info("Main.gd has been modified", MYMOD_LOG)
