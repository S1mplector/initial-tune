extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_pressed():
	var track_data = get_node("/root/TrackData")
	var track_scene_path = track_data.get_selected_track_scene()
	
	# Load selected track
	var map
	if ResourceLoader.exists(track_scene_path):
		map = load(track_scene_path)
	else:
		map = preload("res://scenes/race/map/akina/Akina.tscn")
	
	var car = preload("res://scenes/car/Car.tscn")
	
	var map_instance = map.instantiate()
	var car_instance = car.instantiate()
	
	var car_body = car_instance.get_node("CarBody")
	var tune_data = get_node("/root/TuneData")
	update_tune(car_body, tune_data)
	car_body.is_mouse_and_keyboard = not $"../../../Additional/Gamepad".is_pressed()
	
	map_instance.add_child(car_instance)
	map_instance.gamemode = "TimeAttack"
	map_instance.set_gamemode()
	
	#get_tree().get_root().get_node("Main").get_node("MainMenu").get_node("BGM").stop()
	get_tree().get_root().get_node("Main").get_node("MainMenu").queue_free()
	get_tree().get_root().get_node("Main").add_child(map_instance)
	get_node("/root/GameOption").reset_shader()
	get_node("/root/GameOption").set_music(
		$"../../../Additional/MusicSelect/MusicOption".get_item_text(
			$"../../../Additional/MusicSelect/MusicOption".get_selected_id()
		))
	map_instance.start()
	
func update_tune(car_body, tune_data):
	car_body.engine_power = tune_data.engine_power
	car_body.gear_ratio = tune_data.gear_ratio.duplicate()
	car_body.final_drive_ratio = tune_data.final_drive_ratio
	car_body.steering_angle = tune_data.steering_angle
	car_body.steering_weight_multiplier = tune_data.steering_weight_multiplier
	car_body.weight = tune_data.weight
	car_body.friction = tune_data.friction
	car_body.brake_power = tune_data.brake_power
	car_body.max_rpm = tune_data.max_rpm
	car_body.traction_fast = tune_data.traction_fast
	car_body.traction_slow = tune_data.traction_slow
	car_body.slip_speed = tune_data.slip_speed
	car_body.drag = tune_data.drag
	
