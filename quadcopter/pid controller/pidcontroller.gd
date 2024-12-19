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
	
func compute(delta, desired_value, actual_value):
	
	prev_error = error
	error = shortest_angle_diff(actual_value, desired_value)
	
	print("error: ", error)
	
	var error_rate = (error-prev_error)/delta
	
	error_sum += error * delta
	
	var proportional = error * Kp
	var integral = error_sum * Ki
	var derivative = error_rate * Kd
	
	return clamp(proportional + integral + derivative, clamp_min, clamp_max)


func shortest_angle_diff(a:float, b:float):
	
	# Compute the raw difference
	var diff = b - a
	
	# Normalize the difference to the range -π to π
	if diff > PI:
		diff -= TAU
	elif diff < -PI:
		diff += TAU
	
	return diff
