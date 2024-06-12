extends AnimationPlayer

@onready var color_rect = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	play("fadein")
