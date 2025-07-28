extends Node

const SETTINGS_PATH = "user://inputsettings.tres"

#this thing actually contains all the settings
var res:InputMapRes

func save_settings(input_map:InputMapRes=res):
	ResourceSaver.save(input_map, SETTINGS_PATH)
	update_input_map()

func load_settings():
	if ResourceLoader.exists(SETTINGS_PATH, "InputMapRes"):
		res = ResourceLoader.load(SETTINGS_PATH)
		update_input_map()
	else:
		res = load("res://user settings/DefaultInputMap.tres").duplicate(true)
		
	return res

#replaces the event that triggers an action with a new action (in the input map from projectsettings)
func replace_event(action_name, new_event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)
	
#actually update the input map in projectsettings with the mappings from res
func update_input_map():
	var actions = InputMap.get_actions()
	for action in actions:
		# Skip built-in UI actions
		if action.begins_with("ui_"):
			continue

		# Replace event if defined in InputSettings
		if action in InputSettings.res:
			replace_event(action, InputSettings.res.get(action))
