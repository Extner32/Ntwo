extends Node

const air_density = 1.225 #in kg/m^3
const air_drag = 1

var velocity := 0.0
var total_thrust := 0.0
var drag_force := 0.0

var imu_values := [0.0, 0.0, 0.0]

func reset():
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		reset()


func rates_function(x, max_rate, center_rate, expo):
	#x is in the range [-1, 1]
	#you can see a desmos graph here:
	#https://www.desmos.com/calculator/5hlbr3utht
	var expo_factor = x*(pow(x, 5) * expo + x*(1.0-expo))
	#this is multiplied by sign(x) so it also works for x < 0
	return (center_rate*x)+((max_rate-center_rate)*expo_factor) * sign(x)

var throttle_expo = 1.0

func throttle_curve_function(x, expo):
	return pow(x, 1+expo)

#throttle
func raw_throttle():
	if InputSettings.res.throttle_0_at_center:
		return Input.get_action_strength("throttle_up")
	else:
		return (Input.get_axis("throttle_down", "throttle_up") + 1)/2

func get_throttle_input():
	return throttle_curve_function(raw_throttle(), throttle_expo)
	
#pitch
func raw_pitch():
	return clamp(Input.get_axis("pitch_up", "pitch_down"), -1, 1)
	
func get_pitch_input():
	return rates_function(raw_pitch(), deg_to_rad(RatesSettings.res.pitch_max_rate), deg_to_rad(RatesSettings.res.pitch_center_rate), RatesSettings.res.pitch_expo)
	
#roll
func raw_roll():
	return clamp(Input.get_axis("roll_left", "roll_right"), -1, 1)

func get_roll_input():
	return rates_function(raw_roll(), deg_to_rad(RatesSettings.res.roll_max_rate), deg_to_rad(RatesSettings.res.roll_center_rate), RatesSettings.res.roll_expo)
	
#yaw
func raw_yaw():
	return clamp(Input.get_axis("yaw_left", "yaw_right"), -1, 1)

func get_yaw_input():
	return rates_function(raw_yaw(), deg_to_rad(RatesSettings.res.yaw_max_rate), deg_to_rad(RatesSettings.res.yaw_center_rate), RatesSettings.res.yaw_expo)
