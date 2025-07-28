extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			on_menu_exit()
			visible = false
		else:
			on_menu_open()
			visible = true
		


func _on_resume_button_pressed() -> void:
	visible = false
	on_menu_exit()
	
func _on_settings_button_pressed() -> void:
	hide()
	$"../SettingsMenu".show()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func on_menu_open():
	get_tree().paused = true

func on_menu_exit():
	get_tree().paused = false
