#Hello there
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_button_pressed():
	print("HERE")
	get_tree().change_scene_to_file("res://Scenes/Levels/test_death.tscn")


func _on_credits_button_pressed():
	$CanvasLayer.visible = true


func _on_close_button_pressed():
	$CanvasLayer.visible = false
