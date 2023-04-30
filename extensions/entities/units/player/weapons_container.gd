extends "res://entities/units/player/weapons_container.gd"


func update_weapons_positions(weapons:Array)->void :
	if RunData.effects["blade_storm"].size() > 0:
		var i2idx = {3:5, 4:3, 5:4}
		var node_name = "_six_weapons_attachment_%d"
		var plus_angle = 0.3333333 * PI
		if weapons.size() == 1:
			node_name = "_one_weapon_attachment_%d"
			plus_angle = 0.5 * PI
		if weapons.size() == 2:
			node_name = "_two_weapons_attachment_%d"
			plus_angle = 0.0 * PI
		if weapons.size() == 3:
			node_name = "_three_weapons_attachment_%d"
			plus_angle = 0.166666 * PI
		if weapons.size() == 4:
			node_name = "_four_weapons_attachment_%d"
			plus_angle = 0.25 * PI
			i2idx = {}
		if weapons.size() == 5:
			i2idx = {3:4, 4:3}
			node_name = "_five_weapons_attachment_%d"
		
		var angle = TAU / weapons.size()
		var attack_range = max(Utils.get_stat("stat_range") * 1.0 / 100 + 1.2, 0.0)
		
		for i in weapons.size():
			var position = self.get(node_name % (i + 1)).position
			if weapons.size() == 2:
				position.y = 0
			var real_idx = i
			if i2idx.has(i):
				real_idx = i2idx[i]
			weapons[i].attach(position * attack_range, real_idx * angle + plus_angle)
	else:
		.update_weapons_positions(weapons)
