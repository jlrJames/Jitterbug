extends Area2D

var speed = 700
var direction: Vector2
@onready var animation = $AnimationPlayer

func _ready():
	animation.play("fire")

func _process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if area.name == "EnemyHurtBox":
		#print("player hit")
		queue_free()

	if area.name == "obstacle_fountain":
		queue_free()

func _on_body_entered(body):
	if body is TileMap:
		queue_free()
