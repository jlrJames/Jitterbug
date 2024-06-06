extends CharacterBody2D

signal shoot
signal healthChanged
signal healthZero
@export var standardSpeed = 300.0
var boostedSpeed = standardSpeed * 2
var speedBoost = false
@export var maxHealth = 10
@onready var currentHealth = maxHealth
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
var can_shoot
var single_bullet = preload("res://Scenes/Bullets/player_single_bullet.tscn")
var shotgun_bullet = preload("res://Scenes/Bullets/player_shotgun_bullet.tscn")
var follow_bullet = preload("res://Scenes/Bullets/player_follow_bullet.tscn")
@export var fire_type = 1
# 1 - normal
# 2 - shotgun
# 3 - follow

func _ready():
	Global.playerBody = self

func player_movement():
	var dir = Vector2.ZERO
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if (!speedBoost):
		velocity = dir.normalized() * standardSpeed
	else :
		velocity = dir.normalized() * boostedSpeed
		
func aim_fire():
	var bullet = follow_bullet.instantiate()
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.global_position = global_position
	bullet.rotation = bullet.direction.angle()
	get_tree().get_root().add_child(bullet)
	
func fire():
	if fire_type == 1:
		var bullet = single_bullet.instantiate()
		bullet.direction = get_global_mouse_position() - global_position
		bullet.global_position = global_position
		get_tree().get_root().add_child(bullet)
	elif fire_type == 2:
		var direction = get_global_mouse_position() - global_position
		var bullet1 = shotgun_bullet.instantiate()
		bullet1.direction = direction
		bullet1.global_position = global_position
		#bullet1.shotgun = true
		get_tree().get_root().add_child(bullet1)
			
		var angle_offset = deg_to_rad(10)
		var bullet2 = shotgun_bullet.instantiate()
		bullet2.direction = direction.rotated(angle_offset)
		bullet2.global_position = global_position
		#bullet2.shotgun = true
		get_tree().get_root().add_child(bullet2)

		var bullet3 = shotgun_bullet.instantiate()
		bullet3.direction = direction.rotated(-angle_offset)
		bullet3.global_position = global_position
		#bullet3.shotgun = true
		get_tree().get_root().add_child(bullet3)
	elif fire_type == 3:
		aim_fire()

	can_shoot = false
	$ShotTimer.start()


func update_animation():
	if velocity != Vector2.ZERO:
		animation.play("Run")
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
	else:
		animation.play("Idle")
		
func frame_freeze(timeScale, duration):
	sprite.modulate = Color.CRIMSON
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	sprite.modulate = Color.WHITE
	Engine.time_scale = 1

func _on_shot_timer_timeout():
	can_shoot = true

func _on_player_hitbox_area_entered(area):
	if area.is_in_group("EnemyBullet"):
		#print("Bullet Hit")
		currentHealth -= 1
		healthChanged.emit()
		# Check if health is at 0, emit death signal
		if self.currentHealth <= 0:
			healthZero.emit()
		else:
			frame_freeze(0.1, .4)

func _on_player_pick_up_area_entered(area):
	if area.name == "SpeedPowerup":
		speed_boost()
		sprite.modulate = Color.YELLOW

func speed_boost():
	$SpeedBoost.start()
	speedBoost = true

func _on_speed_boost_timeout():
	speedBoost = false
	sprite.modulate = Color.WHITE

func _physics_process(delta):
	player_movement()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		fire()
	update_animation()
	move_and_slide()
