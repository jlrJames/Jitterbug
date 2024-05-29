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

func _ready():
	Global.playerBody = self

func player_movement():
	var dir = Vector2.ZERO
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if (!speedBoost):
		velocity = dir.normalized() * standardSpeed
	else :
		velocity = dir.normalized() * boostedSpeed
	
func player_mouse():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
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
	player_mouse()
	update_animation()
	move_and_slide()
