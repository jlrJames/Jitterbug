extends Area2D

func _ready():
	$AnimationPlayer.play("idle")

func _on_area_entered(area):
	if area.name == "player_pick_up":
		queue_free()
