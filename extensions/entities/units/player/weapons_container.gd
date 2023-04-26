extends "res://entities/units/player/weapons_container.gd"


func update_weapons_positions(weapons:Array)->void :
	if RunData.effects["blade_storm"].size() > 0:
		for i in weapons.size():
			var real_idx = i
			if i == 3:
				real_idx = 5
			if i == 4:
				real_idx = 3
			if i == 5:
				real_idx = 4
			weapons[i].attach(self.get("_six_weapons_attachment_%d" % (i + 1)).position, (real_idx+1) * 0.3333333 * PI )
	else:
		.update_weapons_positions(weapons)
