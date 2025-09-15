class_name PIDcontroller
extends Node

@export var Kp = 0.0
@export var Ki = 0.0
@export var Kd = 0.0
@export var Kfeedforward = 0.0

@export var filter_strength = 100
var error_buffer = []

#decreases the pid output at higher throttle
@export var throttle_influence = 0.0

@export var clamp_min = -1.0
@export var clamp_max = 1.0

var error = 0
var prev_error = 0

var filtered_error = 0
var prev_filtered_error = 0

var error_sum = 0

var prev_actual_value = 0
	
func compute(delta, desired_value, actual_value):
	
	prev_error = error
	error = desired_value - actual_value
	
	prev_filtered_error = filtered_error

	error_buffer.append(error)
	if len(error_buffer) > filter_strength:
		error_buffer.pop_front()
		
	filtered_error = average(error_buffer)
		
	
	
	
	
	var proportional = error * Kp

	var error_rate = (filtered_error-prev_filtered_error)/delta
	var derivative = error_rate * Kd
	
	#average of current and previous error is a better approximation than 
	#just using error
	#error_sum += ((error+prev_error)/2) * delta * Ki
	error_sum += error * delta
	var integral = error_sum * Ki
	
	var feedforward = (actual_value - prev_actual_value)*Kfeedforward
		
	var output = clamp(proportional + integral + derivative + feedforward, clamp_min, clamp_max)
	var abs_output = abs(output)
	
	output = sign(output) * (abs_output - (abs_output*gb.raw_throttle()) * throttle_influence)
	prev_actual_value = actual_value
	
	return output


func reset():
	error = 0
	prev_error = 0
	error_sum = 0
	
func average(array):
	var result := 0.0
	for val in array:
		result += val
		
	return result/len(array)
