extends Control

var counting = false
var elapsed_time = 0
var best_time = 0.0
var half_time = false

func _ready():
	load_best_time()
	update_best_time_display()

func _process(delta):
	if counting:
		if half_time:
			elapsed_time += (delta/2)
		else:
			elapsed_time += delta
		$Time.text = str(elapsed_time).pad_decimals(2)
		
		# Color feedback based on best time comparison
		if best_time > 0:
			if elapsed_time < best_time:
				$Time.set("theme_override_colors/font_color", Color(0.4, 1, 0.4, 1))
			else:
				$Time.set("theme_override_colors/font_color", Color(1, 0.4, 0.4, 1))
		
func reset():
	elapsed_time = 0.0
	$Time.text = str(elapsed_time).pad_decimals(2)
	$Time.set("theme_override_colors/font_color", Color(0.4, 1, 0.4, 1))
	counting = false

func stop():
	counting = false
	check_new_best()
	
func start():
	counting = true

func toggle_halftime():
	half_time = !half_time

func load_best_time():
	var track_data = get_node_or_null("/root/TrackData")
	if track_data:
		var data = track_data.get_selected_track_data()
		best_time = data.get("best_time", 0.0)

func update_best_time_display():
	var best_label = get_node_or_null("BestTime")
	if best_label:
		if best_time > 0:
			best_label.text = str(best_time).pad_decimals(2)
		else:
			best_label.text = "---"

func check_new_best():
	if elapsed_time > 0 and (best_time <= 0 or elapsed_time < best_time):
		best_time = elapsed_time
		update_best_time_display()
		$Time.set("theme_override_colors/font_color", Color(1, 0.85, 0.3, 1))

func get_elapsed_time() -> float:
	return elapsed_time
