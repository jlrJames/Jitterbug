extends Area2D

@export var speed = 700
var direction: Vector2
#@onready var animation = $AnimationPlayer

func _ready():
	#animation.play("fire")
	$ShootSound.play()
	pass

func _process(delta):
	translate(direction.normalized() * speed * delta)
	#position += speed * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if area.name == "EnemyHurtBox":
		#print("enemy hit")
		queue_free()

	if area.name == "obstacle_fountain":
		queue_free()

func _on_body_entered(body):
	if body is TileMap:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
