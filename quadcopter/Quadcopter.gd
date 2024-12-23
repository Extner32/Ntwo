class_name Quadcopter
extends RigidBody3D

@export var debug_cam = false

@export var motor1: Motor
@export var motor2: Motor
@export var motor3: Motor
@export var motor4: Motor

@onready var motors = [motor1, motor2, motor3, motor4]

#drag in the (local) x, y, z directions
#if for example the y drag is high (top-bottom):
	#if the top/bottom is facing the same direction
	#as the direction that the quad is moving in, the drone will slow down
@export var drag_coefficients = Vector3(0.05, 0.1, 0.05)

var imu_pitch_speed = 0
var imu_roll_speed = 0
var imu_yaw_speed = 0

var imu_pitch = 0
var imu_roll = 0
var imu_yaw = 0


func _process(delta):
	imu_pitch = rotation.x
	imu_roll = rotation.z
	imu_yaw = rotation.y
	
	var local_angular_velocity = angular_velocity * basis
	
	imu_pitch_speed = local_angular_velocity.x
	imu_roll_speed = local_angular_velocity.z
	imu_yaw_speed = local_angular_velocity.y
	
	$FPVCam.current = not debug_cam
	$DebugCamPivot/DebugCam.current = debug_cam
	$DebugCamPivot.global_position = global_position
	$DebugCamPivot.global_rotation.y = global_rotation.y
	
	gb.velocity = linear_velocity.length()
	#print(imu_pitch, imu_roll, imu_yaw)
	
func _physics_process(delta):
	var total_thrust = 0
	#set forces per motor
	for motor in motors:
		var thrust = motor.compute_thrust()
		total_thrust += thrust
		#print("thrust ",thrust)
		var torque = motor.compute_torque()
		
		apply_force(motor.up * thrust, global_transform.basis * motor.position)
		apply_torque(motor.up * torque)
		
	gb.total_thrust = total_thrust
	
	var vel_norm = linear_velocity.normalized()
	var drag_directions = Vector3(0, 0, 0)
	drag_directions.x = abs(global_basis.x.dot(vel_norm))*drag_coefficients.x
	drag_directions.y = abs(global_basis.y.dot(vel_norm))*drag_coefficients.y
	drag_directions.z = abs(global_basis.z.dot(vel_norm))*drag_coefficients.z
	
	var drag = drag_directions.x + drag_directions.y + drag_directions.z
	var drag_force = (vel_norm * linear_velocity.length_squared()) * gb.air_drag * drag
	#print(drag)
	apply_central_force(-drag_force)
		
		
	if Input.is_action_just_pressed("reset"):
		gb.reset()
