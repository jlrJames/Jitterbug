extends Node2D
@onready var level_manager = $LevelManager


# Called when the node enters the scene tree for the first time.
func _ready():
	# Init the level_manager meta date here! 
	# Do this for each new level
	level_manager.set_meta("on_death_scene", "res://Scenes/Levels/game_over.tscn")
	#print(level_manager.get_meta("on_death_scene"))
	
	level_manager.set_meta("num_enemies", 2)
	#print(level_manager.get_meta("num_enemies"))
	
	level_manager.set_meta("next_level_scene", "res://Scenes/Levels/level_4.tscn")
	#print(level_manager.get_meta("next_level_scene"))
