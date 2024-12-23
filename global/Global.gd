extends Node

const air_density = 1.225 #in kg/m^3
const air_drag = 1

var roll_speed := 0
var input_roll := 0

var velocity := 0
var total_thrust := 0

#max_rate, center_rate, expo
#rates are using the Actual Rates

var pitch_max_rate := deg_to_rad(800)
var pitch_center_rate := 0
var pitch_expo := 0

var roll_max_rate := deg_to_rad(800)
var roll_center_rate := 0
var roll_expo := 0

var yaw_max_rate := deg_to_rad(800)
var yaw_center_rate := 0
var yaw_expo := 0

var throttle_max := 5

func reset():
	get_tree().reload_current_scene()
