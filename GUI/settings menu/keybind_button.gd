extends Button

@export var action_name:String = "pitch_up"

var event = null

var last_event = null
var prev_last_event = null

var waiting = false

func _ready():
	event = InputMap.action_get_events(action_name)[0]
	text = get_formatted_event(event)

func _input(event: InputEvent) -> void:
	prev_last_event = last_event
	
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		return
	if event is InputEventJoypadMotion and abs(event.axis_value) < 0.5:
		return
		
	last_event = event


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		text = "input any action"
		if prev_last_event != last_event:
			waiting = false
			text = get_formatted_event(last_event)
				
			


func _on_pressed() -> void:
	waiting = true

func get_formatted_event(ev):
	if ev is InputEventJoypadMotion:
		return "Axis: "+str(ev.axis)
	if ev is InputEventJoypadButton:
		return "Button: "+str(ev.button_index)
	if ev is InputEventKey:
		return "Key: "+str(OS.get_keycode_string(ev.keycode))
	else:
		return "Unkown Event: "+str(ev)
