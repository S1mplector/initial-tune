extends TextureButton

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		go_back()

func _on_pressed():
	go_back()

func go_back():
	var main_menu_button = get_node("/root/GameOption").main_menu_button.instantiate()
	var screen = get_tree().get_root().find_child("Screen", true, false)
	var controls = get_tree().get_root().find_child("Controls", true, false)
	if screen and controls:
		screen.add_child(main_menu_button)
		controls.queue_free()
