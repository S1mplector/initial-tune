extends Node

# Arcade Stage OST
var thunder = 0
var lets_go = 0

# All music tracks for random playback
var all_music = []

var main_menu = 0
var main_menu_button = 0
var race_select = 0
var credit = 0
var control = 0

func _ready():
	main_menu = preload("res://scenes/menu/MainMenu.tscn")
	main_menu_button = preload("res://scenes/menu/MainMenuButton.tscn")
	race_select = preload("res://scenes/menu/RaceSelect.tscn")
	credit = preload("res://scenes/menu/Credits.tscn")
	control = preload("res://scenes/menu/Controls.tscn")
	
	# Load Arcade Stage OST
	thunder = preload("res://assets/music/arcadestageost/1-01. Thunder -Out of Control-.mp3")
	lets_go = preload("res://assets/music/arcadestageost/1-02. Let's Go, Come On.mp3")
	
	# Build list of all tracks for random playback
	all_music = [thunder, lets_go]

func reset_shader():
	get_tree().get_root().find_child("Shader", true, false).get_child(0).queue_free()
	get_tree().get_root().find_child("Shader", true, false).add_child(preload("res://scenes/ShaderVCR.tscn").instantiate())

func set_music(music_data):
	var music_player = get_tree().get_root().get_node("Main").get_node("Music")
	music_player.stop()
	
	if music_data == "Random":
		play_random_music()
		return
	elif music_data == "Thunder":
		music_player.stream = thunder
	elif music_data == "Let's Go Come On":
		music_player.stream = lets_go
	else:
		play_random_music()
		return
	music_player.play()

func play_random_music():
	var music_player = get_tree().get_root().get_node("Main").get_node("Music")
	music_player.stop()
	var random_track = all_music[randi() % all_music.size()]
	music_player.stream = random_track
	music_player.play()

func set_volume(volume):
	get_tree().get_root().get_node("Main").get_node("Music").volume_db = volume

func get_volume():
	return get_tree().get_root().get_node("Main").get_node("Music").volume_db
