extends AudioStreamPlayer2D
var dead
var track1 = preload("res://Assets/Futuristic Science Dungeon.mp3")

func play_track(track):
	if self.stream != track:
		self.stream = track
		self.play()


func _ready():
	self.play_track(self.track1)
	dead = false

func _process(delta):
	pass
	# I commented this code out because it was causing errors and I cant replicate the game crash described
	
	# All of this code here
	# makes it so when the player dies or goes back to the main menu
	# THe game does not crash
	# THen it puts the background music player on top of the player 
	#var real_name = ""
	#var cur_scene_name = get_tree().current_scene
	#if cur_scene_name:
	#	real_name = cur_scene_name.name
	#print(real_name)
	#if real_name != "gameOver" and real_name != "Win" and Global.playerBody and Global.playerBody.position:
	#	self.position = Global.playerBody.position
	
