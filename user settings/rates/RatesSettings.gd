extends Node

const SETTINGS_PATH = "user://ratessettings.tres"

var res:RatesRes

var rates_menu = null

var res_default = preload("res://user settings/rates/DefaultRates.tres")

func save_settings():
	rates_menu.write_rate_settings()
	ResourceSaver.save(res, SETTINGS_PATH)
	
	

func load_settings():
	if ResourceLoader.exists(SETTINGS_PATH, "RatesRes"):
		res = ResourceLoader.load(SETTINGS_PATH)
		print('loaded res'+str(res))
	else:
		res = res_default.duplicate(true)
		print('created new res'+str(res))
		
	rates_menu.load_rate_settings()
