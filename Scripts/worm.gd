extends CharacterBody2D

const bullet_scene = preload("res://Scenes/Bullets/butterfly_bullet.tscn")
const maxHealth = 10
var currentHealth = maxHealth
@onready var shoot_timer = $Shoot
@onready var rotater = $Rotater
const speed = 20
var dir: Vector2
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
var player: CharacterBody2D
var is_chase: bool
const rotate_speed = 0
const shooter_timer_wait_time = 1
const radius = 10
const spawn_point_count = 6
signal enemy_die

func _ready():
	is_chase = false
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()
	
func _process(delta):
	move(delta)
	update_animations()
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func move(delta):
	if is_chase:
		player = Global.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	if !is_chase:
		velocity += dir * speed * delta
	move_and_slide()
		
func _on_move_timeout():
	$Move.wait_time = choose([0.8, .9, 1.0, 1.2])
	if !is_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])

func update_animations():
	animation.play("walk")
	if dir.x == -1:
		sprite.flip_h = true
	elif dir.x == 1:
		sprite.flip_h = false

func choose(array):
	array.shuffle()
	return array.front()

func _on_shoot_timeout():
	for s in rotater.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation

func _on_player_enter_body_entered(body):
	if body == Global.playerBody:
		is_chase = true

func _on_player_enter_body_exited(body):
	if body == Global.playerBody:
		is_chase = false

func die():
	queue_free()
	enemy_die.emit()

func _on_enemy_hurt_box_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		#print("Enemy Hit!")
		print(area.name)
		if area.name == "PlayerIncreasedDamageBullet":
			currentHealth -= 3
		else:
			currentHealth -= 1
		sprite.modulate = Color(10,10,10,10)
		await get_tree().create_timer(0.05).timeout
		sprite.modulate = Color.WHITE
		
	if currentHealth <= 0:
		die()
