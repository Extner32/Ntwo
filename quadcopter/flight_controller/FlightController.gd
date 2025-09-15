extends Node3D

@export var quadcopter: Quadcopter

@export var motor1: Motor
@export var motor2: Motor
@export var motor3: Motor
@export var motor4: Motor

@onready var motors = [motor1, motor2, motor3, motor4]

#motor idle pwm
var motor_idle = 0.1

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

@onready var PID_pitch = $PID_pitch
@onready var PID_roll =$PID_roll
@onready var PID_yaw = $PID_yaw


func _physics_process(delta):
	if armed:
		#get input and (rates are already applied)
		var input_throttle = gb.get_throttle_input()
		var input_pitch = -gb.get_pitch_input()
		var input_roll = -gb.get_roll_input()
		var input_yaw = -gb.get_yaw_input()
		
		#make the PIDs figure out the new speeds for pitch, roll and yaw
		var pitch_speed = PID_pitch.compute(delta, input_pitch, quadcopter.imu_pitch_speed)
		var roll_speed = PID_roll.compute(delta, input_roll, quadcopter.imu_roll_speed)
		var yaw_speed = PID_yaw.compute(delta, input_yaw, quadcopter.imu_yaw_speed)
		

		#mix the pitch, roll and yaw speeds to the velocites of the motors
		var motors = [
			motor_idle + input_throttle  - pitch_speed + roll_speed + yaw_speed,
			motor_idle + input_throttle  + pitch_speed + roll_speed - yaw_speed,
			motor_idle + input_throttle  - pitch_speed - roll_speed - yaw_speed,
			motor_idle + input_throttle  + pitch_speed - roll_speed + yaw_speed
			]
		
		# scale the motors so the the fastest motor is 1 and the slowest is 0
		var max_motor = motors.max()
		var min_motor = motors.min()
		
		#Shift all motors up if any are below 0
		if min_motor < 0.0:
			for i in range(4):
				motors[i] -= min_motor

		#Scale all motors down if any are above 1
		if max_motor > 1.0:
			var s = 1.0 / max_motor
			for i in range(4):
				motors[i] *= s
				
		motor1.pwm = motors[0]
		motor2.pwm = motors[1]
		motor3.pwm = motors[2]
		motor4.pwm = motors[3]
		
		$Graphs/GraphA.data.append(input_pitch)
		$Graphs/GraphB.data.append(quadcopter.imu_pitch_speed)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("self_right"):
		quadcopter.global_rotation.z = 0
		quadcopter.global_rotation.x = 0
		reset()
	


	

func reset():
	PID_pitch.reset()
	PID_roll.reset()
	PID_yaw.reset()
