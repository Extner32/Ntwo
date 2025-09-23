extends VBoxContainer

func _ready() -> void:
	gb.settings_menu_ref = self

func _on_save_and_close_button_pressed() -> void:
	InputSettings.save_settings()
	SimulatorSettings.save_settings()
	hide()
	$"../PauseMenu".show()
