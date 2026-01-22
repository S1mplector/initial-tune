extends Control

@onready var track_name_label = $TrackName
@onready var track_desc_label = $TrackDescription
@onready var track_preview = $TrackPreview
@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var difficulty_label = $DifficultyLabel
@onready var best_time_label = $BestTimeLabel

var current_index = 0
var track_types = []

func _ready():
	var track_data = get_node("/root/TrackData")
	track_types = track_data.get_all_track_types()
	current_index = track_types.find(track_data.selected_track)
	if current_index < 0:
		current_index = 0
	
	# Hide navigation if only one track
	if track_types.size() <= 1:
		if left_button:
			left_button.visible = false
		if right_button:
			right_button.visible = false
	
	update_display()

func _on_left_button_pressed():
	current_index -= 1
	if current_index < 0:
		current_index = track_types.size() - 1
	select_track()

func _on_right_button_pressed():
	current_index += 1
	if current_index >= track_types.size():
		current_index = 0
	select_track()

func select_track():
	var track_type = track_types[current_index]
	var track_data = get_node("/root/TrackData")
	track_data.set_selected_track(track_type)
	update_display()

func update_display():
	var track_type = track_types[current_index]
	var track_data = get_node("/root/TrackData")
	var data = track_data.get_track_data(track_type)
	
	if track_name_label:
		track_name_label.text = "Map: " + data["name"]
	
	if track_desc_label:
		track_desc_label.text = data["description"]
	
	if track_preview:
		var texture = load(data["preview"]) if ResourceLoader.exists(data["preview"]) else null
		if texture:
			track_preview.texture = texture
	
	if difficulty_label:
		difficulty_label.text = "Difficulty: " + data["difficulty"]
	
	if best_time_label:
		if data["best_time"] > 0:
			best_time_label.text = "Record: %.2fs by %s" % [data["best_time"], data["best_time_holder"]]
		else:
			best_time_label.text = "Record: Not Set"
