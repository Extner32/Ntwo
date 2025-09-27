extends VBoxContainer

func _ready() -> void:
	await owner.ready #wait for GUI to add it self to global (gb.gui_ref)
	gb.gui_ref.stack_append(self)

func _on_sandbox_button_pressed() -> void:
	gb.gui_ref.stack_append($"../MapSelectMenu")

func _on_settings_button_pressed() -> void:
	gb.gui_ref.stack_append($"../SettingsMenu")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
