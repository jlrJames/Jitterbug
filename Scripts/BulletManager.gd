extends Node2D

@export var bullet_scene: PackedScene

func _on_player_heart_shoot(pos, dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.rotation = dir.angle()
	bullet.add_to_group("bullets")
