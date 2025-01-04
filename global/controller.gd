extends Node

#max_rate, center_rate, expo
#rates are using the Actual Rates

var pitch_max_rate := deg_to_rad(800)
var pitch_center_rate := deg_to_rad(250)
var pitch_expo := 1.0

var roll_max_rate := deg_to_rad(800)
var roll_center_rate := deg_to_rad(250)
var roll_expo := 1.0

var yaw_max_rate := deg_to_rad(800)
var yaw_center_rate := deg_to_rad(250)
var yaw_expo := 1.0

#16
var throttle_max := 16.0

var throttle_zero_center = false

func rates_function(x, max_rate, center_rate, expo):
	#x is in the range [-1, 1]
	#you can see a desmos graph here:
	#https://www.desmos.com/calculator/5hlbr3utht
	var expo_factor = x*(pow(x, 5) * expo + x*(1.0-expo))
	#this is multiplied by sign(x) so it also works for x < 0
	return (center_rate*x)+((max_rate-center_rate)*expo_factor) * sign(x)
	

func raw_throttle():
	if throttle_zero_center:
		return Input.get_action_strength("throttle_up")
	else:
		return (Input.get_axis("throttle_down", "throttle_up") + 1)/2

func get_throttle_input():
	return raw_throttle() * throttle_max
	
	
func raw_pitch():
	return clamp(Input.get_axis("pitch_up", "pitch_down"), -1, 1)
	
func get_pitch_input():
	return rates_function(raw_pitch(), pitch_max_rate, pitch_center_rate, pitch_expo)
	
func raw_roll():
	return clamp(Input.get_axis("roll_left", "roll_right"), -1, 1)

func get_roll_input():
	return rates_function(raw_roll(), roll_max_rate, roll_center_rate, roll_expo)
	
func raw_yaw():
	return clamp(Input.get_axis("yaw_left", "yaw_right"), -1, 1)

func get_yaw_input():
	return rates_function(raw_yaw(), yaw_max_rate, yaw_center_rate, yaw_expo)
