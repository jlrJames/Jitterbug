extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_heart_health_zero():
	get_tree().change_scene_to_file(str(self.get_meta("on_death_scene")))


func when_enemy_die():
	await get_tree().create_timer(3).timeout
	var cur_enemy_count
	cur_enemy_count = self.get_meta("num_enemies")
	cur_enemy_count -= 1
	print("enemy count: ", cur_enemy_count)
	if cur_enemy_count == 0:
		$PassPlayer.play()
		# added null check for a random crash when trying to change scene
		if get_tree():
			get_tree().change_scene_to_file(str(self.get_meta("next_level_scene")))
	else:
		self.set_meta("num_enemies", cur_enemy_count)

func _on_butterfly_enemy_enemy_die():
	when_enemy_die()


func _on_butterfly_enemy_2_enemy_die():
	when_enemy_die()

func _on_worm_enemy_die():
	when_enemy_die()
