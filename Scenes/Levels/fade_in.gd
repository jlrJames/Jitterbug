extends AnimationPlayer

@onready var credits_button = $CreditsButton

# Called when the node enters the scene tree for the first time.
func _ready():
	play("fadein")
