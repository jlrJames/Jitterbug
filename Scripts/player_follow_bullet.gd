extends Area2D

var direction: Vector2
@export var speed = 300
var target = null

func _process(delta):
	translate(direction * speed * delta)
	if target and is_instance_valid(target):
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)
	else:
		target = null

func _on_area_entered(area):
	if area.name == "EnemyHurtBox":
		#print("enemy hit")
		queue_free()

func _on_aiming_area_body_entered(body):
	if body.is_in_group("Enemy"):
		#print("Bullet See")
		target = body

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
