extends Effect


#static func get_id()->String:
#	return "character_exploding_effect"
#
#func apply()->void :
#	if custom_key != "" or storage_method == StorageMethod.KEY_VALUE:
#		RunData.effects[custom_key].push_back([key, value])
#	elif storage_method == StorageMethod.REPLACE:
#		base_value = RunData.effects[key]
#		RunData.effects[key] = value
#	else :
#		RunData.effects[key] += value
#
#
#func unapply()->void :
#	if custom_key != "" or storage_method == StorageMethod.KEY_VALUE:
#		RunData.effects[custom_key].erase([key, value])
#	elif storage_method == StorageMethod.REPLACE:
#		RunData.effects[key] = base_value
#	else :
#		RunData.effects[key] -= value
