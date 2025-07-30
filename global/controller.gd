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
