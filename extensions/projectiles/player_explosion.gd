extends "res://projectiles//player_explosion.gd"



func set_area(p_area:float)->void :
	# calculate area in function explode.
	scale = Vector2(p_area, p_area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
