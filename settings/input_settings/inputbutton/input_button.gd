extends Button

@export var action_name = ""

var event:InputEvent
var waiting_for_input := false
var display_text := ""

const STICK_INPUT_THRESHOLD = 0.5


func _ready() -> void:
	display_text = text
	event = InputSettings.get_property(action_name)
	text = format_text(event)

func _on_gui_input(ev: InputEvent) -> void:
	if waiting_for_input:
		if ev is InputEventKey and ev.is_pressed():
			on_finished_input(ev)
			return

		if ev is InputEventJoypadButton and ev.is_pressed():
			on_finished_input(ev)
			return
			
		if ev is InputEventJoypadMotion:
			if abs(ev.axis_value) >= STICK_INPUT_THRESHOLD:
				on_finished_input(ev)
				return
				
		else:
			if ev is InputEventMouseButton or ev is InputEventMouseMotion:
				return
			else:
				on_finished_input(ev)


func _process(delta: float) -> void:
	if waiting_for_input:
		self.grab_focus()

func _on_pressed() -> void:
	waiting_for_input = true
	text = "flip switch or move stick"


func on_finished_input(ev:InputEvent):
	waiting_for_input = false
	text = format_text(ev)
	InputSettings.set_property(action_name, ev)
	event = ev
	

func format_text(ev:InputEvent):
	return display_text+" ["+format_input_event(ev)+"]"

func format_input_event(event:InputEvent):
	if event is InputEventKey:
		return "key: "+event.as_text_keycode()
		
	elif event is InputEventJoypadButton:
		return "Switch: "+str(event.button_index)
		
	elif event is InputEventJoypadMotion:
		return "Axis: "+str(event.axis)+" direction: "+str(round(event.axis_value))
		
	else:
		return "unknown event: "+str(event)
