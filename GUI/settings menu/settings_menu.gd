extends Control



func _on_exit_settings_button_pressed() -> void:
	hide()
	InputSettings.save_settings()
	RatesSettings.save_settings()
	$"../PauseMenu".show()
