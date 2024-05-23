extends CharacterBody2D

signal shoot
@export var speed: float = 100.0
@onready var animation = $AnimationPlayer
var can_shoot

func _ready():
	can_shoot = true

func player_movement():
	var dir = Vector2.ZERO
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = dir.normalized() * speed
	
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
			$Sprite2D.flip_h = true
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
	else:
		animation.play("Idle")

func _on_shot_timer_timeout():
	can_shoot = true
	
func _physics_process(delta):
	player_movement()
	player_mouse()
	update_animation()
	move_and_slide()

