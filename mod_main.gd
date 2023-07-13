extends Node

const MOD_DIR = "Jay-Rock/"
const MYMODNAME_LOG = "Jay-Rock"

var dir = ""
var ext_dir = ""
var trans_dir = ""

func _init(modLoader = ModLoader):
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	ext_dir = dir + "extensions/"
	trans_dir = dir + "translations/"

	# Add extensions
	ModLoaderMod.install_script_extension(ext_dir + "main.gd")
	ModLoaderMod.install_script_extension(ext_dir + "entities/units/enemies/enemy.gd")
	ModLoaderMod.install_script_extension(ext_dir + "entities/units/player/player.gd")
	ModLoaderMod.install_script_extension(ext_dir + "ui/menus/run/character_selection.gd")
	ModLoaderMod.install_script_extension(ext_dir + "singletons/weapon_service.gd")
	ModLoaderMod.install_script_extension(ext_dir + "singletons/run_data.gd")
	ModLoaderMod.install_script_extension(ext_dir + "singletons/text.gd")
	ModLoaderMod.install_script_extension(ext_dir + "projectiles/player_explosion.gd")
	ModLoaderMod.install_script_extension(ext_dir + "entities/units/player/weapons_container.gd")
	ModLoaderMod.install_script_extension(ext_dir + "singletons/progress_data.gd")
	var new_potato = preload("res://mods-unpacked/Jay-Rock/extensions/weapons/melee/melee_weapon.gd")
	new_potato.take_over_path("res://weapons/melee/melee_weapon.gd")
	new_potato = preload("res://mods-unpacked/Jay-Rock/extensions/weapons/ranged/ranged_weapon.gd")
	new_potato.take_over_path("res://weapons/ranged/ranged_weapon.gd")
	new_potato = preload("res://mods-unpacked/Jay-Rock/extensions/effects/items/item_exploding_effect.gd")
	new_potato.take_over_path("res://effects/items/item_exploding_effect.gd")
#	new_potato = preload("res://mods-unpacked/Jay-Rock/extensions/weapons/ranged/ranged_weapon.gd")
#	new_potato.take_over_path("res://weapons/ranged/ranged_weapon.gd")
	

	# Add translations
	ModLoaderMod.add_translation(trans_dir + "jay_text.en.translation")
	ModLoaderMod.add_translation(trans_dir + "jay_text.zh.translation")

func _add_my_items()->void: # ! `void` means it doesn't return anything
	var BorItemService = load(dir + "/singletons/bor_item_service.tscn").instance()
	ItemService.characters.append_array(BorItemService.characters)

func _ready():
	_add_my_items();
	ModLoaderLog.info("Done", MYMODNAME_LOG)
