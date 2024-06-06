# Sprites are taken by https://pixel-boy.itch.io/ninja-adventure-asset-pack
extends Node2D

@export var bullet_scene: PackedScene

func _on_player_heart_shoot(pos, dir):
	var bullet = bullet_scene.instantaiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.rotation = dir.angle()
	bullet.add_to_group("bullets")
