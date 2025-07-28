class_name KeybindButton
extends Button

@export var action_name:String = "pitch_up"

var event = null

var last_event = null
var prev_last_event = null

var waiting := false
var explanation := ""

signal event_changed(action_name, event)

func _ready():
	event = InputMap.action_get_events(action_name)[0]
	explanation = text
	text = explanation+" "+get_formatted_event(event)

func _input(ev: InputEvent) -> void:
	prev_last_event = last_event
	
	if ev is InputEventMouseMotion or ev is InputEventMouseButton:
		return
	if ev is InputEventJoypadMotion and abs(ev.axis_value) < 0.5:
		return
		
	last_event = ev


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		text = "press button or move stick"
		if prev_last_event != last_event:
			waiting = false
			event = last_event
			
			event_changed.emit(action_name, last_event)
			
			text = explanation+" "+get_formatted_event(last_event)
				
			

func set_event(new_event:InputEvent):
	event = new_event
	text = explanation+" "+get_formatted_event(last_event)
	

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
		return "Event: "+str(ev)
