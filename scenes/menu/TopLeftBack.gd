extends Button

func _ready():
	pressed.connect(_on_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		go_back()

func _on_pressed():
	go_back()

func go_back():
	var main_menu_button = get_node("/root/GameOption").main_menu_button.instantiate()
	var screen = get_tree().get_root().find_child("Screen", true, false)
	var race_select = get_tree().get_root().find_child("RaceSelect", true, false)
	if screen and race_select:
		screen.add_child(main_menu_button)
		race_select.queue_free()
