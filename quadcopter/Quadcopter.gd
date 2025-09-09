class_name Quadcopter
extends RigidBody3D

@export var debug_cam = false

@export var motor1: Motor
@export var motor2: Motor
@export var motor3: Motor
@export var motor4: Motor

@onready var motors = [motor1, motor2, motor3, motor4]

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


#drag in the (local) x, y, z directions
#if for example the y drag is high (top-bottom):
	#if the top/bottom is facing the same direction
	#as the direction that the quad is moving in, the drone will slow down
@export var XYZ_projected_areas = Vector3(0.02, 0.05, 0.02)
@export var drag_coeff = 1.0

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
	
	#these are all for the HUD
	gb.velocity = linear_velocity.length()
	gb.imu_values[0] = imu_pitch
	gb.imu_values[1] = imu_roll
	gb.imu_values[2] = imu_yaw

	
func _physics_process(delta):
	var total_thrust = 0
	#set forces per motor
	var prop_drag = 0
	
	for motor in motors:
		var thrust = motor.compute_thrust()
		var ground_effect = motor.compute_ground_effect()
		total_thrust += thrust
		#print("thrust ",thrust)
		var torque = motor.compute_torque()
		var drag_torque = motor.compute_drag_torque()
		prop_drag += motor.compute_prop_drag()
		
		apply_force(motor.up * thrust * ground_effect, global_transform.basis * motor.position)
		apply_torque(motor.up * torque)
		apply_torque(motor.up * drag_torque)
		
		
	gb.total_thrust = total_thrust
	#peruno is from 0-1 instead of 0-100%
	var thrust_peruno = total_thrust/70
	audio.volume_db = linear_to_db(thrust_peruno*0.5)
	audio.pitch_scale = pow(2, thrust_peruno)
	
	

	var drag_mult =  drag_coeff * (0.5 + 0.5 / (1.0 + linear_velocity.length() * 0.1))
	
	var vel_norm = linear_velocity.normalized()
	var drag_directions = Vector3(0, 0, 0)
	
	drag_directions.x = pow(global_basis.x.dot(vel_norm), 2)*XYZ_projected_areas.x * drag_mult
	drag_directions.y = pow(global_basis.y.dot(vel_norm), 2)*XYZ_projected_areas.y * drag_mult
	drag_directions.z = pow(global_basis.z.dot(vel_norm), 2)*XYZ_projected_areas.z * drag_mult
	
	var drag = drag_directions.x + drag_directions.y + drag_directions.z
	var drag_force = (vel_norm * linear_velocity.length_squared()) * (drag+prop_drag)
	
	gb.drag_force = drag_force.length()
	apply_central_force(-drag_force)
