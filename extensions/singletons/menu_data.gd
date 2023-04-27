extends "res://singletons/menu_data.gd"

const MOD_DIR = "Jay-Rock/"

func _init():
	if ModLoader != null:
		var dir = ModLoader.UNPACKED_DIR + MOD_DIR
		var ext_dir = dir + "extensions/"
		ModLoader.install_script_extension(ext_dir + "weapons/weapon.gd")
