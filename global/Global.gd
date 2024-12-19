extends Node

const air_density = 1.225 #in kg/m^3
const air_drag = 1

var roll_speed = 0
var input_roll = 0

var velocity = 0
var total_thrust = 0

func reset():
	get_tree().reload_current_scene()
