extends Area2D

func _ready():
	$AnimationPlayer.play("Idle")

func _on_area_entered(area):
	#print(area)
	if area.name == "player_pick_up":
		queue_free()
