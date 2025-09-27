extends Control
class_name DataPlotter

@export var max_data_len := 100
@export var stream_colors :Array[Color]
@export var border_color := Color(0.187, 0.187, 0.187, 1.0)

@export var data_min := -1.0
@export var data_max := 1.0

var data_streams = []

func _ready() -> void:
	for i in range(len(stream_colors)):
		data_streams.append([])

func add_data(value:float, stream_idx:int):
	var stream = data_streams[stream_idx]
	stream.append(value)
	if len(stream) > max_data_len:
		stream.pop_front()
		
	queue_redraw()
	
func clear_stream(stream_idx:int):
	data_streams[stream_idx].clear()



func _draw() -> void:
	var delta_x = float(size.x)/max_data_len
	
	for i in range(len(data_streams)):
		var stream = data_streams[i]
		if len(stream) <= 1:
			continue
		for j in range(len(stream)-1):
			draw_line(
				Vector2(j*delta_x, clamp(remap(stream[j], data_min, data_max, 0, size.y), 0, size.y)),
				Vector2((j+1)*delta_x, clamp(remap(stream[j+1], data_min, data_max, 0, size.y), 0, size.y)),
				stream_colors[i]
				)

	draw_rect(Rect2(Vector2(0, 0), size), border_color, false)
