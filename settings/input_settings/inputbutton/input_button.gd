extends Button

@export var action_name = ""
@export var invert_progressbar = false

var event:InputEvent
var waiting_for_input := false
var display_text := ""

const STICK_INPUT_THRESHOLD = 0.5


func _ready() -> void:
	display_text = text
	event = InputSettings.get_property(action_name)
	text = format_text(event)
	if invert_progressbar:
		$ProgressBar.fill_mode = 1
	else:
		$ProgressBar.fill_mode = 0

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
	else:
		$ProgressBar.value = Input.get_action_strength(action_name)

func _on_pressed() -> void:
	waiting_for_input = true
	text = "flip switch or move stick"


func on_finished_input(ev:InputEvent):
	waiting_for_input = false
	text = format_text(ev)
	InputSettings.set_property(action_name, ev)
	event = ev
	self.grab_focus()
	

func format_text(ev:InputEvent):
	return display_text+" ["+format_input_event(ev)+"]"

func format_input_event(ev:InputEvent):
	if event is InputEventKey:
		return "key: "+ev.as_text_keycode()
		
	elif event is InputEventJoypadButton:
		return "Switch: "+str(ev.button_index)
		
	elif event is InputEventJoypadMotion:
		return "Axis: "+str(ev.axis)+" direction: "+str(round(ev.axis_value))
		
	else:
		return "unknown event: "+str(ev)
