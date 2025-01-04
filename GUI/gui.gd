extends Control

@export var fps_gradient: Gradient
var good_fps = DisplayServer.screen_get_refresh_rate()
var fps = 0

func _process(delta: float) -> void:
	
	#to go from m/s to Km/h you need to multiply by 3.6
	$VelocityLabel.text = "velocity: "+str(snapped(gb.velocity*3.6, 0.01)) + " Km/h"
	#in Newton
	$ThrustLabel.text = "total thrust: "+str(snapped(gb.total_thrust, 0.01)) + " N"
	
	fps = Engine.get_frames_per_second()
	$FPSLabel.text = "FPS: "+str(fps)
	$FPSLabel.add_theme_color_override("font_color", fps_gradient.sample(fps/good_fps))

	#this just sets the values for the plots
	$RatePlots/Pitch.material.set_shader_parameter("max_rate", Controller.pitch_max_rate)
	$RatePlots/Pitch.material.set_shader_parameter("center_rate", Controller.pitch_center_rate)
	$RatePlots/Pitch.material.set_shader_parameter("expo", Controller.pitch_expo)
	
	$RatePlots/Roll.material.set_shader_parameter("max_rate", Controller.roll_max_rate)
	$RatePlots/Roll.material.set_shader_parameter("center_rate", Controller.roll_center_rate)
	$RatePlots/Roll.material.set_shader_parameter("expo", Controller.roll_expo)
	
	$RatePlots/Yaw.material.set_shader_parameter("max_rate", Controller.yaw_max_rate)
	$RatePlots/Yaw.material.set_shader_parameter("center_rate", Controller.yaw_center_rate)
	$RatePlots/Yaw.material.set_shader_parameter("expo", Controller.yaw_expo)
