extends "res://singletons/text.gd"


func _ready()->void:
	_bor_add_keys_needing_operator()
	_bor_add_keys_needing_percent()


# Custom
# =============================================================================

#@note: These use `text_key`, not just `key`

# Adds +/-, eg `stat_max_hp`
func _bor_add_keys_needing_operator()->void:
	keys_needing_operator["effect_accum_stat_speed"] = [0]
	keys_needing_operator["effect_accum_stat_armor"] = [0]
	keys_needing_operator["effect_accum_explosion_size"] = [0]


# Adds %, eg `number_of_enemies`
func _bor_add_keys_needing_percent()->void:
	keys_needing_percent["effect_accum_stat_speed"] = [0]

