extends Node

const INPUTSETTINGSRES_PATH = "user://inputsettings.tres"
var all_actions = [
	"throttle_up", "throttle_down",
	"pitch_up", "pitch_down",
	"roll_left", "roll_right",
	"yaw_left", "yaw_right",
	"arm",
	"self_right", "reset"
]

var inputsettings_res:InputSettingsRes


func _ready():
	load_settings()

func load_settings():
	
	#there is no save file yet
	if not ResourceLoader.exists(INPUTSETTINGSRES_PATH):
		inputsettings_res = load("res://settings/input_settings/default_inputsettings_res.tres").duplicate(true)
	#there is a savefile
	else:
		inputsettings_res = ResourceLoader.load(INPUTSETTINGSRES_PATH)
	replace_actions()
	

func save_settings():
	replace_actions()
	ResourceSaver.save(inputsettings_res, INPUTSETTINGSRES_PATH)


func set_property(property, value):
	InputSettings.inputsettings_res.set(property, value)
	#if the property that we're setting is a action_event pair, then update the InputMap with the new event
	if InputMap.has_action(property):
		replace_action_event(property, value)
	
func get_property(property):
	return InputSettings.inputsettings_res.get(property)

func replace_action_event(action:StringName, event:InputEvent):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)

#replaces the events in the InputMap with the events from inputsettings_res
func replace_actions():
	for action in all_actions:
		replace_action_event(action, inputsettings_res.get(action))
