class_name PIDcontroller
extends Node

@export var Kp = 0.0
@export var Ki = 0.0
@export var Kd = 0.0

@export var clamp_min = -1.0
@export var clamp_max = 1.0

var error = 0
var prev_error = 0
var error_sum = 0

var saturated = false
	
func compute(delta, desired_value, actual_value):
	
	prev_error = error
	
	error = desired_value - actual_value
	var proportional = error * Kp

	var error_rate = (error-prev_error)/delta
	var derivative = error_rate * Kd
	
	#average of current and previous error is a better approximation than 
	#just using error
	#error_sum += ((error+prev_error)/2) * delta * Ki
	error_sum += error * delta
		
	var integral = error_sum * Ki
		
	var output = clamp(proportional + integral + derivative, clamp_min, clamp_max)
	
	return output


func shortest_angle_diff(a:float, b:float):
	
	# Compute the raw difference
	var diff = b - a
	
	# Normalize the difference to the range -π to π
	if diff > PI:
		diff -= TAU
	elif diff < -PI:
		diff += TAU
	
	return diff
