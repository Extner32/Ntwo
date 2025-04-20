class_name Propeller
extends Node3D

var speed := 0.0
var ground_effect_strength = 1.0
const MAX_SPEED := 3.0
@export var color_gradient: Gradient

func _process(delta: float) -> void:
	$MeshInstance3D.material_override.albedo_color = color_gradient.sample(speed/MAX_SPEED)


func ground_effect():
	if not $RayCast3D.is_colliding():
		return 1.0
		
	var raycast_local = $RayCast3D.get_collision_point() - $RayCast3D.global_position
	var ground_distance = raycast_local.length()
	#  "inspired by":
	#Characterization of the Aerodynamic Ground Effect and Its Influence in Multirotor Control
	var thrust_mult = 1.0/pow(4.0*ground_distance, 2) + 1.0 * ground_effect_strength
	thrust_mult = min(thrust_mult, 1.5)
	return thrust_mult
