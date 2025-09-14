extends Node

var pitch_center_rate = 250.0
var pitch_max_rate = 800.0
var pitch_expo = 1.0

var roll_center_rate = 250.0
var roll_max_rate = 800.0
var roll_expo = 1.0

var yaw_center_rate = 250.0
var yaw_max_rate = 800.0
var yaw_expo = 1.0


func get_property(property:String):
	return get(property)
