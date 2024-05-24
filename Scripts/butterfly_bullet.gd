extends Area2D

var speed = 700
var direction: Vector2
@onready var animation = $AnimationPlayer

func _process(delta):
	position += speed * transform.x * delta
	animation.play("shoot")


func _on_timer_timeout():
	queue_free()
