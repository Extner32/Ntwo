extends Node

const SIMULATORSETTINGSRES_PATH = "user://simulatorsettings.tres"

var simulatorsettings_res:SimulatorSettingsRes

func _ready():
	load_settings()

func load_settings():
	#there is no save file yet
	if not ResourceLoader.exists(SIMULATORSETTINGSRES_PATH):
		simulatorsettings_res = load("res://settings/simulator_settings/default_simulatorsettings_res.tres").duplicate(true)
	#there is a savefile
	else:
		simulatorsettings_res = ResourceLoader.load(SIMULATORSETTINGSRES_PATH)
		
func save_settings():
	ResourceSaver.save(simulatorsettings_res, SIMULATORSETTINGSRES_PATH)

func set_property(property, value):
	SimulatorSettings.simulatorsettings_res.set(property, value)
	
func get_property(property):
	return SimulatorSettings.simulatorsettings_res.get(property)
