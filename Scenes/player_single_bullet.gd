extends Area2D

var speed = 700
var direction: Vector2

func _process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()
