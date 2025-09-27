@tool

extends ColorRect

func _process(_delta: float) -> void:
	material.set("shader_parameter/aspect_ratio", float(size.y)/float(size.x))
