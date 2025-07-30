@tool
extends ColorRect

@export var graph_color:Color = Color(1, 0, 0, 1)
@export var background_color:Color = Color(0, 0, 0, 0)

var center_rate := 250.0
var max_rate := 800.0
var expo := 1.0

func _process(delta: float) -> void:
	material.set_shader_parameter("graph_color", graph_color)
	material.set_shader_parameter("background_color", background_color)
	
	material.set_shader_parameter("center_rate", center_rate)
	material.set_shader_parameter("max_rate", max_rate)
	material.set_shader_parameter("expo", expo)
