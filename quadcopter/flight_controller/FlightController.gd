extends Node3D

@export var quadcopter: Quadcopter

@export var motor1: Motor
@export var motor2: Motor
@export var motor3: Motor
@export var motor4: Motor

@onready var motors = [motor1, motor2, motor3, motor4]
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const MOTOR_IDLE = 0.2

#rates

#PID controllers

#motor config:

#-> <-
#4   2
# \ /
#  Î
# / \
#3   1
#-> <-

var armed = true

#0.1, 0.4, 0.001
@onready var PID_pitch = $PID_pitch
@onready var PID_roll =$PID_roll
@onready var PID_yaw = $PID_yaw



func _physics_process(delta):
	if armed:
		#get input and apply rates
		var input_throttle = get_throttle_input() * gb.throttle_max
		var input_pitch = rates_function(get_pitch_input(), gb.pitch_max_rate, gb.pitch_center_rate, gb.pitch_expo)
		var input_roll = rates_function(get_roll_input(), gb.roll_max_rate, gb.roll_center_rate, gb.roll_expo)
		var input_yaw = rates_function(get_yaw_input(), gb.yaw_max_rate, gb.yaw_center_rate, gb.yaw_expo)
		
		
		#make the PIDs figure out the new speeds for pitch, roll and yaw
		var pitch_speed = PID_pitch.compute(delta, input_pitch, quadcopter.imu_pitch_speed)
		var roll_speed = PID_roll.compute(delta, input_roll, quadcopter.imu_roll_speed)
		var yaw_speed = PID_yaw.compute(delta, input_yaw, quadcopter.imu_yaw_speed)
		
		gb.input_roll = input_roll
		gb.roll_speed = quadcopter.imu_roll_speed
		

		#mix the pitch, roll and yaw speeds to the velocites of the motors
		motor1.angular_vel = max(MOTOR_IDLE + input_throttle  - pitch_speed + roll_speed + yaw_speed, 0)
		motor2.angular_vel = max(MOTOR_IDLE + input_throttle  + pitch_speed + roll_speed - yaw_speed, 0)
		motor3.angular_vel = max(MOTOR_IDLE + input_throttle  - pitch_speed - roll_speed - yaw_speed, 0)
		motor4.angular_vel = max(MOTOR_IDLE + input_throttle  + pitch_speed - roll_speed + yaw_speed, 0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("self_right"):
		quadcopter.global_rotation.x = 0
		quadcopter.global_rotation.z = 0
		quadcopter.global_rotation.y = PI
		reset()

	
func rates_function(x, max_rate, center_rate, expo):
	#x is in the range [-1, 1]
	#you can see a desmos graph here:
	#https://www.desmos.com/calculator/5hlbr3utht
	var expo_factor = x*(pow(x, 5) * expo + x*(1.0-expo))
	#this is multiplied by sign(x) so it also works for x < 0
	return (center_rate*x)+((max_rate-center_rate)*expo_factor) * sign(x)
	
func get_throttle_input():
	return (Input.get_axis("throttle_down", "throttle_up") + 1)/2
	
func get_pitch_input():
	var nudge_factor = 1.43
	return -clamp(Input.get_axis("pitch_up", "pitch_down") * nudge_factor, -1, 1)
	
func get_roll_input():
	var nudge_factor = 1.76
	return -clamp(Input.get_axis("roll_left", "roll_right") * nudge_factor, -1, 1)
	
func get_yaw_input():
	var nudge_factor = 1.43
	return -clamp(Input.get_axis("yaw_left", "yaw_right") * nudge_factor, -1, 1)

func reset():
	PID_pitch.reset()
	PID_roll.reset()
	PID_yaw.reset()
