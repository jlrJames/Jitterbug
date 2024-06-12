extends CharacterBody2D

signal shoot
signal healthChanged
signal healthZero
@export var standardSpeed = 300.0
var boostedSpeed = standardSpeed * 2
var speedBoost = false
var shieldPowerup = false
var increasedDamage = false
@export var maxHealth = 15
@onready var currentHealth = maxHealth
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
var can_shoot
var single_bullet = preload("res://Scenes/Bullets/player_single_bullet.tscn")
var shotgun_bullet = preload("res://Scenes/Bullets/player_shotgun_bullet.tscn")
var follow_bullet = preload("res://Scenes/Bullets/player_follow_bullet.tscn")
var increased_damage_bullet = preload("res://Scenes/Bullets/player_increased_damage_bullet.tscn")
@export var fire_type = 1
# 1 - normal
# 2 - shotgun
# 3 - follow

func _ready():
	if Global.playerHealth:
		currentHealth = Global.playerHealth
	Global.playerBody = self

func player_movement():
	var dir = Vector2.ZERO
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if (!speedBoost):
		velocity = dir.normalized() * standardSpeed
	else :
		velocity = dir.normalized() * boostedSpeed
		
func aim_fire():
	var bullet
	if !increasedDamage:
		bullet = follow_bullet.instantiate()
	else:
		bullet = increased_damage_bullet.instantiate()
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.global_position = global_position
	bullet.rotation = bullet.direction.angle()
	get_tree().get_root().add_child(bullet)
	
func fire():
	if fire_type == 1:
		var bullet
		if !increasedDamage:
			bullet = single_bullet.instantiate()
		else:
			bullet = increased_damage_bullet.instantiate()
		bullet.direction = get_global_mouse_position() - global_position
		bullet.global_position = global_position
		get_tree().get_root().add_child(bullet)
	elif fire_type == 2:
		var direction = get_global_mouse_position() - global_position
		var bullet1
		var bullet2
		var bullet3
		
		bullet1 = shotgun_bullet.instantiate()
		bullet1.direction = direction
		bullet1.global_position = global_position
		get_tree().get_root().add_child(bullet1)
		
		bullet2 = shotgun_bullet.instantiate()
		var angle_offset = deg_to_rad(10)
		bullet2.direction = direction.rotated(angle_offset)
		bullet2.global_position = global_position
		get_tree().get_root().add_child(bullet2)
		
		bullet3 = shotgun_bullet.instantiate()
		bullet3.direction = direction.rotated(-angle_offset)
		bullet3.global_position = global_position
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
	if area.is_in_group("EnemyBullet") and !shieldPowerup:
		#print("Bullet Hit")
		$DamagePlayer.play()
		currentHealth -= 1
		healthChanged.emit()
		Global.playerHealth = currentHealth
		# Check if health is at 0, emit death signal
		if self.currentHealth <= 0:
			healthZero.emit()
		else:
			frame_freeze(0.1, .4)

func _on_player_pick_up_area_entered(area):
	if area.name.substr(0, 12) == "SpeedPowerup":
		speed_boost()
	elif area.name.substr(0, 13) == "ShieldPowerup":
		shield()
	elif area.name.substr(0, 21) == "DamageIncreasePowerup":
		increased_damage()
	elif area.name.substr(0, 14) == "ShotgunPowerup":
		shotgun()
	elif area.name.substr(0, 19) == "FollowBulletPowerup":
		follow()
		
func turn_off_everthing():
	if $SheildTimer.time_left > 0:
		$SheildTimer.stop()
		$SheildTimer.emit_signal("timeout")
	
	if $IncreasedDamageTimer.time_left > 0:
		$IncreasedDamageTimer.stop()
		$IncreasedDamageTimer.emit_signal("timeout")
		
	if $SpeedBoostTimer.time_left > 0:
		$SpeedBoostTimer.stop()
		$SpeedBoostTimer.emit_signal("timeout")
	
	if $ShotgunTimer.time_left > 0:
		$ShotgunTimer.stop()
		$ShotgunTimer.emit_signal("timeout")
	
	if $FollowTimer.time_left > 0:
		$FollowTimer.stop()
		$FollowTimer.emit_signal("timeout")

func shotgun():
	turn_off_everthing()
	$ShotgunPlayer.play()
	fire_type = 2
	$ShotgunTimer.start()
	sprite.modulate = Color.WHITE
		
func follow():
	turn_off_everthing()
	$FollowUpPlayer.play()
	fire_type = 3
	$FollowTimer.start()
	sprite.modulate = Color.WHITE

func speed_boost():
	turn_off_everthing()
	$SpeedUpPlayer.play()
	$SpeedBoostTimer.start()
	speedBoost = true
	sprite.modulate = Color.YELLOW

func shield():
	turn_off_everthing()
	$SheildUpPlayer.play()
	$SheildTimer.start()
	shieldPowerup = true
	sprite.modulate = Color.SKY_BLUE
	
func increased_damage():
	turn_off_everthing()
	$DamageUpPlayer.play()
	fire_type = 1
	increasedDamage = true
	$IncreasedDamageTimer.start()
	sprite.modulate = Color.DARK_RED

func _on_speed_boost_timeout():
	speedBoost = false
	sprite.modulate = Color.WHITE
	
func _on_sheild_timer_timeout():
	shieldPowerup = false
	sprite.modulate = Color.WHITE
	
func _on_increased_damage_timer_timeout():
	increasedDamage = false
	sprite.modulate = Color.WHITE

func _on_shotgun_timer_timeout():
	fire_type = 1

func _on_follow_timer_timeout():
	fire_type = 1

func _physics_process(delta):
	player_movement()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		fire()
	update_animation()
	move_and_slide()

