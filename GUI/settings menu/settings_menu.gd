extends Control



func _on_exit_settings_button_pressed() -> void:
	hide()
	$"../PauseMenu".show()
