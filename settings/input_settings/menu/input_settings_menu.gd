extends MarginContainer

@onready var preview: Node3D = $HBoxContainer/Preview/PanelContainer/SubViewportContainer/SubViewport/Node3D/transform

var preview_rotation_amount = 20

func _process(delta: float) -> void:
	preview.global_rotation.x = deg_to_rad(Input.get_axis("pitch_up", "pitch_down")) * preview_rotation_amount
	preview.global_rotation.z = deg_to_rad(Input.get_axis("roll_left", "roll_right")) * preview_rotation_amount
	preview.global_rotation.y = deg_to_rad(Input.get_axis("yaw_right", "yaw_left")) * preview_rotation_amount
