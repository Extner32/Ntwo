extends MarginContainer

@onready var model: Node3D = $settings/Example/ViewportContainer/SubViewport/transform
var target_rotation := Vector3.ZERO
var rotation_pull := TAU*0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_rotation.x = Controller.raw_pitch() * rotation_pull
	$settings/ScrollContainer/directionals/Pitch/ProgressBar.value = Input.get_action_strength("pitch_up")
	$settings/ScrollContainer/directionals/Pitch/ProgressBar2.value = Input.get_action_strength("pitch_down")
	
	target_rotation.z = Controller.raw_roll() * rotation_pull
	$settings/ScrollContainer/directionals/Roll/VBoxContainer/ProgressBar3.value = Input.get_action_strength("roll_left")
	$settings/ScrollContainer/directionals/Roll/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("roll_right")
	
	target_rotation.y = -Controller.raw_yaw() * rotation_pull
	$settings/ScrollContainer/directionals/Yaw/VBoxContainer/ProgressBar3.value = Input.get_action_strength("yaw_left")
	$settings/ScrollContainer/directionals/Yaw/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("yaw_right")
	
	$settings/ScrollContainer/directionals/Throttle/ProgressBar4.value = Controller.raw_throttle()
	
	model.rotation = target_rotation
	model.global_basis = model.global_basis.orthonormalized()


func _on_check_box_toggled(toggled_on: bool) -> void:
	Controller.throttle_zero_center = toggled_on
