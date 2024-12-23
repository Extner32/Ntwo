extends Node2D

@export var size := Vector2i(100, 100)
@export var buffer_max_len := 100.0
@export var max_value := 1.0
@export var min_value := -1.0

@export var data_color := Color(1, 0, 0)
@export var border_color := Color(0, 0, 0)

var data = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(data) > buffer_max_len:
		data.pop_front()
	queue_redraw()
	
func _draw():
	draw_rect(Rect2(global_position, size), border_color, false)
	
	var diff = abs(min_value)+abs(max_value)
	
	var step = float(size.x)/float(buffer_max_len)
	var height_scale = float(size.y)/diff
	var center = (abs(min_value)*height_scale)
	
	for i in range(len(data)-1):
		var current = clamp(data[i], min_value, max_value)
		var next = clamp(data[i+1], min_value, max_value)
		draw_line(
		Vector2(i*step, size.y - (center+current*height_scale)) + global_position,
		Vector2((i+1)*step, size.y - (center+next*height_scale)) + global_position,
		data_color
		)
		
	
