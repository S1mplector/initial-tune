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
	get_tree().get_root().find_child("Screen", true, false).add_child(main_menu_button)
	get_tree().get_root().find_child("RaceSelect", true, false).queue_free()
