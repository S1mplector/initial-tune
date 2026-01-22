extends Control

@onready var car_name_label = $CarName
@onready var car_desc_label = $CarDescription
@onready var car_preview = $CarPreview
@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var stats_container = $StatsContainer

var current_index = 0
var car_types = []

func _ready():
	var car_data = get_node("/root/CarData")
	var tune_data = get_node("/root/TuneData")
	car_types = car_data.get_all_car_types()
	current_index = car_types.find(car_data.selected_car)
	if current_index < 0:
		current_index = 0
	
	# Load initial car defaults
	tune_data.load_car_defaults(car_types[current_index])
	update_display()

func _on_left_button_pressed():
	current_index -= 1
	if current_index < 0:
		current_index = car_types.size() - 1
	select_car()

func _on_right_button_pressed():
	current_index += 1
	if current_index >= car_types.size():
		current_index = 0
	select_car()

func select_car():
	var car_type = car_types[current_index]
	var car_data = get_node("/root/CarData")
	var tune_data = get_node("/root/TuneData")
	car_data.set_selected_car(car_type)
	tune_data.load_car_defaults(car_type)
	update_display()

func update_display():
	var car_type = car_types[current_index]
	var car_data = get_node("/root/CarData")
	var data = car_data.get_car_data(car_type)
	
	if car_name_label:
		car_name_label.text = data["name"]
	
	if car_desc_label:
		car_desc_label.text = data["description"]
	
	if car_preview:
		var texture = load(data["sprite"]) if ResourceLoader.exists(data["sprite"]) else null
		if texture:
			car_preview.texture = texture
	
	update_stats(data)

func update_stats(data: Dictionary):
	if not stats_container:
		return
	
	var power_bar = stats_container.get_node_or_null("PowerBar")
	var weight_bar = stats_container.get_node_or_null("WeightBar")
	var grip_bar = stats_container.get_node_or_null("GripBar")
	var handling_bar = stats_container.get_node_or_null("HandlingBar")
	
	if power_bar:
		power_bar.value = remap(data["engine_power"], 150, 220, 0, 100)
	if weight_bar:
		weight_bar.value = remap(data["weight"], 1.1, 1.4, 100, 0)
	if grip_bar:
		grip_bar.value = remap(data["traction_slow"], 0.6, 0.85, 0, 100)
	if handling_bar:
		handling_bar.value = remap(data["steering_weight_multiplier"], 0.55, 0.44, 0, 100)
