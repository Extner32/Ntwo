class_name Propeller
extends Node3D

var speed := 0.0
const MAX_SPEED := 3.0
@export var color_gradient: Gradient

func _process(delta: float) -> void:
	$MeshInstance3D.material_override.albedo_color = color_gradient.sample(speed/MAX_SPEED)
