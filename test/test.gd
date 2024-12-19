extends Node2D

var current = 0
var want = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current = $RigidBody2D.rotation
	want += Input.get_axis("roll_left", "roll_right")*delta*2
	want = fposmod(want, TAU)
	var add = $PID.compute(delta, want, current)
	print(add)
	$RigidBody2D.apply_torque(add)
	
	#$RigidBody2D.apply_force(Vector2(100, 0), Vector2(100, 0))
	$Graph.data.append(Input.get_axis("pitch_down", "pitch_up"))
	
	queue_redraw()
	
func _draw() -> void:
	var pos = Vector2(300, 300)
	var r = 290
	draw_line(pos, pos+Vector2(cos(want)*r, sin(want)*r), Color(0, 1, 0))
	draw_line(pos, pos+Vector2(cos(current)*r, sin(current)*r), Color(1, 0, 0))
