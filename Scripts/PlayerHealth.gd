extends TextureProgressBar

@onready var player = $"../../PlayerHeart"

func _ready():
	player.healthChanged.connect(update)
	update()

func update():
	value = player.currentHealth * 100 / player.maxHealth
