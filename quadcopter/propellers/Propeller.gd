class_name Propeller
extends Node3D

var angular_velocity := 0.0
var ground_effect_strength = 1.0
const diameter = 0.127 # = 5 inches
@export var color_gradient: Gradient

func _ready() -> void:
	$MeshInstance3D.mesh.top_radius = diameter/2
	$MeshInstance3D.mesh.bottom_radius = diameter/2

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
