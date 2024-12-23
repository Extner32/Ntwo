class_name Motor
extends Node3D

@export var prop: Propeller
#True: ->
#False: <-
#the direction the motor turns in
@export var direction:bool
@export var on:bool = true

@onready var radius = $MeshInstance3D.mesh.top_radius

const mass = 0.3 #in kg
var inertia_moment = 0

const lift_const = 1.0
const torque_const = 0.1

var angular_vel = 0
var up = Vector3.ZERO

func _ready():
	inertia_moment = (radius*radius) * mass

func compute_thrust():
	if not on: return 0
	#return pow(KvSi, 4) * pow(prop.thrust_multiplier, 2) * pow(KvSi * voltage, 2) * 2*gb.air_density * prop.swept_area
	return lift_const * angular_vel

func compute_torque():
	if not on: return 0
	#return 0.5 * pow(prop.radius, 3) * pow(KvSi*voltage, 2) * gb.air_density * prop.torque_multiplier * prop.cross_sectional_area
	return torque_const * angular_vel * float(int(direction)*2-1)

func _process(delta):
	angular_vel *= int(on)
	up = global_basis.y
	prop.speed = angular_vel
	#print(angular_vel)
