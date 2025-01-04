extends MarginContainer

@onready var model: Node3D = $settings/Example/ViewportContainer/SubViewport/transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	model.rotation.x += Controller.get_pitch_input() * delta
	$settings/ScrollContainer/directionals/Pitch/ProgressBar.value = Input.get_action_strength("pitch_up")
	$settings/ScrollContainer/directionals/Pitch/ProgressBar2.value = Input.get_action_strength("pitch_down")
	
	model.rotation.z += Controller.get_roll_input() * delta
	$settings/ScrollContainer/directionals/Roll/VBoxContainer/ProgressBar3.value = Input.get_action_strength("roll_left")
	$settings/ScrollContainer/directionals/Roll/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("roll_right")
	
	model.rotation.y += Controller.get_yaw_input() * delta
	$settings/ScrollContainer/directionals/Yaw/VBoxContainer/ProgressBar3.value = Input.get_action_strength("yaw_left")
	$settings/ScrollContainer/directionals/Yaw/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("yaw_right")
	
	$settings/ScrollContainer/directionals/Throttle/ProgressBar4.value = Controller.raw_throttle()



func _on_check_box_toggled(toggled_on: bool) -> void:
	Controller.throttle_zero_center = toggled_on
