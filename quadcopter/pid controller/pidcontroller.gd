class_name PIDcontroller
extends Node

@export var Kp := 0.0
@export var Ki := 0.0
@export var Kd := 0.0
@export var Kfeedforward := 0.0

@export var filter_strength := 0.0


#decreases the pid output at higher throttle
@export var throttle_influence := 0.0

@export var clamp_min := -1.0
@export var clamp_max := 1.0

@export var integral_limit := 2.0

var error := 0.0
var prev_error := 0.0
var error_sum := 0.0

var prev_actual_value := 0.0
var filtered_derivative := 0.0

func compute(delta, desired_value, actual_value):
	prev_error = error
	error = desired_value - actual_value
	#P
	var proportional = error * Kp
	#D
	var raw_derivative = (error-prev_error)/delta
	filtered_derivative = lowpass_filter(filtered_derivative, raw_derivative, delta, filter_strength)
	var derivative = filtered_derivative * Kd
	#I
	error_sum += error * delta
	
	var integral = error_sum * Ki
	#feedforward
	var feedforward = actual_value*Kfeedforward
		
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
	
	
func lowpass_filter(prev_value: float, new_value: float, delta: float, tau: float) -> float:
	if tau <= 0.0:
		return new_value  # no filtering
	var alpha = delta / (tau + delta)
	return prev_value + alpha * (new_value - prev_value)
