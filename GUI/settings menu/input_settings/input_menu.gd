extends MarginContainer

@onready var model: Node3D = $settings/Example/ViewportContainer/SubViewport/transform
var target_rotation := Vector3.ZERO
var max_rotation := TAU*0.1

var keybind_buttons = []

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func _ready() -> void:
	InputSettings.input_menu = self
	
	for child in get_all_children($settings/ScrollContainer/VBoxContainer):
		if child is KeybindButton:
			keybind_buttons.append(child)
			child.event_changed.connect(_on_input_map_change)
			
	InputSettings.load_settings()
	InputSettings.update_input_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_rotation.x = gb.raw_pitch() * max_rotation
	$settings/ScrollContainer/VBoxContainer/Pitch/ProgressBar.value = Input.get_action_strength("pitch_up")
	$settings/ScrollContainer/VBoxContainer/Pitch/ProgressBar2.value = Input.get_action_strength("pitch_down")
	
	target_rotation.z = gb.raw_roll() * max_rotation
	$settings/ScrollContainer/VBoxContainer/Roll/VBoxContainer/ProgressBar3.value = Input.get_action_strength("roll_left")
	$settings/ScrollContainer/VBoxContainer/Roll/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("roll_right")
	
	target_rotation.y = -gb.raw_yaw() * max_rotation
	$settings/ScrollContainer/VBoxContainer/Yaw/VBoxContainer/ProgressBar3.value = Input.get_action_strength("yaw_left")
	$settings/ScrollContainer/VBoxContainer/Yaw/VBoxContainer2/ProgressBar4.value = Input.get_action_strength("yaw_right")
	
	$settings/ScrollContainer/VBoxContainer/Throttle/ProgressBar4.value = gb.raw_throttle()
	
	model.rotation = target_rotation
	model.global_basis = model.global_basis.orthonormalized()
	
func _on_input_map_change():
	InputSettings.save_settings()

#gets called when InputSettings.save_settings() is called
func write_input_settings():
	InputSettings.res.pitch_up = $settings/ScrollContainer/VBoxContainer/Pitch/PitchUp.event
	InputSettings.res.pitch_down = $settings/ScrollContainer/VBoxContainer/Pitch/PitchDown.event
	
	InputSettings.res.roll_right = $settings/ScrollContainer/VBoxContainer/Roll/VBoxContainer2/RollRight.event
	InputSettings.res.roll_left = $settings/ScrollContainer/VBoxContainer/Roll/VBoxContainer/RollLeft.event
	
	InputSettings.res.yaw_right = $settings/ScrollContainer/VBoxContainer/Yaw/VBoxContainer2/YawRight.event
	InputSettings.res.yaw_left = $settings/ScrollContainer/VBoxContainer/Yaw/VBoxContainer/YawLeft.event
	
	
	InputSettings.res.throttle_up = $settings/ScrollContainer/VBoxContainer/Throttle/ThrottleUp.event
	InputSettings.res.throttle_down = $settings/ScrollContainer/VBoxContainer/Throttle/ThrottleDown.event
	InputSettings.res.throttle_0_at_center = $settings/ScrollContainer/VBoxContainer/Throttle/HBoxContainer/CheckBox.button_pressed
	
	InputSettings.res.arm = $settings/ScrollContainer/VBoxContainer/Switches/Arm/KeybindButton.event
	InputSettings.res.arm_toggle = $settings/ScrollContainer/VBoxContainer/Switches/Arm/CheckBox.button_pressed
	
	InputSettings.res.reset = $settings/ScrollContainer/VBoxContainer/Switches/Reset/KeybindButton.event
	InputSettings.res.self_right = $settings/ScrollContainer/VBoxContainer/Switches/SelfRight/KeybindButton.event

func load_input_settings():
	$settings/ScrollContainer/VBoxContainer/Throttle/HBoxContainer/CheckBox.button_pressed = InputSettings.res.throttle_0_at_center
	$settings/ScrollContainer/VBoxContainer/Switches/Arm/CheckBox.button_pressed = InputSettings.res.arm_toggle
	
	#the rest gets loaded by the InputSettings singleton
