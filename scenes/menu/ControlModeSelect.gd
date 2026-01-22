extends OptionButton

func _ready():
	# Load current setting
	var game_option = get_node("/root/GameOption")
	if game_option.mouse_control_enabled:
		selected = 1
	else:
		selected = 0
	
	item_selected.connect(_on_item_selected)

func _on_item_selected(index):
	var game_option = get_node("/root/GameOption")
	game_option.mouse_control_enabled = (index == 1)
