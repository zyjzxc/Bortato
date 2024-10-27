extends "res://projectiles//player_explosion.gd"

func _ready():
	._ready()
	if RunData.get_player_effect("explosion_eliminate_bullets", player_index).size() > 0:
		_hitbox.monitoring = true
		_hitbox.collision_mask = 0b10000
		_hitbox.connect("area_entered",self,"_on_Hitbox_area_entered")

func _on_Hitbox_area_entered(area):
	if area.get_parent().name.count("EnemyProjectile"):
		area.get_parent().set_to_be_destroyed()

func set_area(p_area:float)->void :
	# calculate area in function explode.
	scale = Vector2(p_area, p_area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
