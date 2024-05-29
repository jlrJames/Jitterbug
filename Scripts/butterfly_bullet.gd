extends Area2D

var speed = 700
var direction: Vector2
@onready var animation = $AnimationPlayer

func _ready():
	animation.play("shoot")

func _process(delta):
	position += speed * transform.x * delta
	
	#if $RayCast2D.is_colliding():
		#var collider = $RayCast2D.get_collider()
		#if collider.is_in_group("Player"):
			#print("Hit Player!")
			#queue_free()

func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if area.name == "player_hitbox":
		#print("player hit")
		queue_free()
