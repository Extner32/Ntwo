extends Control

@export var fps_gradient: Gradient
var good_fps = DisplayServer.screen_get_refresh_rate()
var fps = 0

	
func _process(delta: float) -> void:
	
	#to go from m/s to Km/h you need to multiply by 3.6
	$DroneStats/VboxContainer/VelocityLabel.text = "velocity: "+str(snapped(gb.velocity*3.6, 0.01)) + " Km/h"
	#in Newton
	$DroneStats/VboxContainer/ThrustLabel.text = "total thrust: "+str(snapped(gb.total_thrust, 0.01)) + " N"
	
	$DroneStats/VboxContainer/DragLabel.text = "drag force: "+str(snapped(gb.drag_force, 0.01)) + " N"
	
	
	fps = Engine.get_frames_per_second()
	$FPSLabel.text = "FPS: "+str(fps)
	$FPSLabel.add_theme_color_override("font_color", fps_gradient.sample(fps/good_fps))

	$Graph.data.append(snapped(gb.imu_rotation_speeds[0], 0.01))
	$GraphInput.data.append(snapped(-gb.get_pitch_input(), 0.01))
