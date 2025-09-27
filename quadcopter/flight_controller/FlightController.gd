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

var armed = false

const MOTOR_SCALE := 1.0/1.5

@onready var PID_pitch = $PID_pitch
@onready var PID_roll =$PID_roll
@onready var PID_yaw = $PID_yaw


func _physics_process(delta):
	if armed:
		# --- Step 1: read inputs ---
		var input_throttle = gb.get_throttle_input()
		var input_pitch = -gb.get_pitch_input()
		var input_roll = -gb.get_roll_input()
		var input_yaw = -gb.get_yaw_input()
		
		

		# --- Step 2: compute PID outputs (desired angular rates vs IMU rates) ---
		var pitch_pid = PID_pitch.compute(delta, input_pitch, quadcopter.imu_pitch_speed)
		var roll_pid  = PID_roll.compute(delta, input_roll, quadcopter.imu_roll_speed)
		var yaw_pid   = PID_yaw.compute(delta, input_yaw, quadcopter.imu_yaw_speed)

		# --- Step 3: motor PID contributions (no throttle yet) ---
		var motor_mix = [
			-pitch_pid + roll_pid + yaw_pid,   # motor1
			 pitch_pid + roll_pid - yaw_pid,   # motor2
			-pitch_pid - roll_pid - yaw_pid,   # motor3
			 pitch_pid - roll_pid + yaw_pid    # motor4
		]

		# --- Step 4: normalize PID authority if range > 1 ---
		var motor_min = motor_mix.min()
		var motor_max = motor_mix.max()
		var motor_range = motor_max - motor_min

		var pid_scale = 1.0
		if motor_range > 1.0:
			pid_scale = 1.0 / motor_range

		for i in range(4):
			motor_mix[i] *= pid_scale

		# --- Step 5: adjust throttle so PID fits into [0,1] ---
		var min_allowed = -motor_min * pid_scale
		var max_allowed = 1.0 - motor_max * pid_scale
		input_throttle = clamp(input_throttle, min_allowed, max_allowed)

		# --- Step 6: add throttle + idle offset, scale, clamp ---
		for i in range(4):
			motor_mix[i] = motor_idle + (input_throttle + motor_mix[i]) * MOTOR_SCALE
			motor_mix[i] = clamp(motor_mix[i], 0.0, 1.0)

		# --- Step 7: apply to motors ---
		motor1.pwm = motor_mix[0]
		motor2.pwm = motor_mix[1]
		motor3.pwm = motor_mix[2]
		motor4.pwm = motor_mix[3]

		$DataPlotter.add_data(input_pitch, 0)
		$DataPlotter.add_data(quadcopter.imu_pitch_speed, 1)

	else:
		motor1.pwm = 0
		motor2.pwm = 0
		motor3.pwm = 0
		motor4.pwm = 0


		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("self_right"):
		quadcopter.global_rotation.z = 0
		quadcopter.global_rotation.x = 0
		reset()
		
	armed = bool(round(Input.get_action_strength("arm")))
	

	


	

func reset():
	PID_pitch.reset()
	PID_roll.reset()
	PID_yaw.reset()
