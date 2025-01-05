extends Node3D

@export var quadcopter: Quadcopter

@export var motor1: Motor
@export var motor2: Motor
@export var motor3: Motor
@export var motor4: Motor

@onready var motors = [motor1, motor2, motor3, motor4]

var motor_idle = 0.2

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
		var input_throttle = Controller.get_throttle_input()
		var input_pitch = -Controller.get_pitch_input()
		var input_roll = -Controller.get_roll_input()
		var input_yaw = -Controller.get_yaw_input()
		
		#make the PIDs figure out the new speeds for pitch, roll and yaw
		var pitch_speed = PID_pitch.compute(delta, input_pitch, quadcopter.imu_pitch_speed)
		var roll_speed = PID_roll.compute(delta, input_roll, quadcopter.imu_roll_speed)
		var yaw_speed = PID_yaw.compute(delta, input_yaw, quadcopter.imu_yaw_speed)
		
		gb.input_roll = input_roll
		gb.roll_speed = quadcopter.imu_roll_speed
		

		#mix the pitch, roll and yaw speeds to the velocites of the motors
		motor1.angular_vel = max(motor_idle + input_throttle  - pitch_speed + roll_speed + yaw_speed, 0)
		motor2.angular_vel = max(motor_idle + input_throttle  + pitch_speed + roll_speed - yaw_speed, 0)
		motor3.angular_vel = max(motor_idle + input_throttle  - pitch_speed - roll_speed - yaw_speed, 0)
		motor4.angular_vel = max(motor_idle + input_throttle  + pitch_speed - roll_speed + yaw_speed, 0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("self_right"):
		quadcopter.global_rotation.z = 0
		quadcopter.global_rotation.x = 0
		reset()

	

func reset():
	PID_pitch.reset()
	PID_roll.reset()
	PID_yaw.reset()
