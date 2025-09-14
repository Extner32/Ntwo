extends HBoxContainer


func _on_button_pressed() -> void:
	InputSettings.save_settings()


func _process(delta: float) -> void:
	$InputButtons/ThrottleUpBar.value = Input.get_action_strength("throttle_up")
	$InputButtons/ThrottleDownBar.value = Input.get_action_strength("throttle_down")
