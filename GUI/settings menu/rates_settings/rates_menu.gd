extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RatesSettings.rates_menu = self
	RatesSettings.load_settings()
	print(RatesSettings.res.pitch_center_rate)
	print(RatesSettings.res_default.resource_path)
	
	#$VBoxContainer/Pitch/Rates/Center.fallback_number = RatesSettings.res_default.pitch_center_rate
	#$VBoxContainer/Pitch/Rates/Max.fallback_number = RatesSettings.res_default.pitch_max_rate
	#$VBoxContainer/Pitch/Rates/Expo.fallback_number = RatesSettings.res_default.pitch_expo
#
	#$VBoxContainer/Roll/Rates/Center.fallback_number = RatesSettings.res_default.roll_center_rate
	#$VBoxContainer/Roll/Rates/Max.fallback_number = RatesSettings.res_default.roll_max_rate
	#$VBoxContainer/Roll/Rates/Expo.fallback_number = RatesSettings.res_default.roll_expo
#
	#$VBoxContainer/Yaw/Rates/Center.fallback_number = RatesSettings.res_default.yaw_center_rate
	#$VBoxContainer/Yaw/Rates/Max.fallback_number = RatesSettings.res_default.yaw_max_rate
	#$VBoxContainer/Yaw/Rates/Expo.fallback_number = RatesSettings.res_default.yaw_expo
	
	$VBoxContainer/Pitch/Rates/Center.fallback_number = 250
	$VBoxContainer/Pitch/Rates/Max.fallback_number = 800
	$VBoxContainer/Pitch/Rates/Expo.fallback_number = 1

	$VBoxContainer/Roll/Rates/Center.fallback_number = 250
	$VBoxContainer/Roll/Rates/Max.fallback_number = 800
	$VBoxContainer/Roll/Rates/Expo.fallback_number = 1

	$VBoxContainer/Yaw/Rates/Center.fallback_number = 250
	$VBoxContainer/Yaw/Rates/Max.fallback_number = 800
	$VBoxContainer/Yaw/Rates/Expo.fallback_number = 1


func _process(delta: float) -> void:
	$VBoxContainer/Pitch/RatePlot.center_rate = $VBoxContainer/Pitch/Rates/Center.get_number()
	$VBoxContainer/Pitch/RatePlot.max_rate = $VBoxContainer/Pitch/Rates/Max.get_number()
	$VBoxContainer/Pitch/RatePlot.expo = $VBoxContainer/Pitch/Rates/Expo.get_number()

	$VBoxContainer/Roll/RatePlot.center_rate = $VBoxContainer/Roll/Rates/Center.get_number()
	$VBoxContainer/Roll/RatePlot.max_rate = $VBoxContainer/Roll/Rates/Max.get_number()
	$VBoxContainer/Roll/RatePlot.expo = $VBoxContainer/Roll/Rates/Expo.get_number()

	$VBoxContainer/Yaw/RatePlot.center_rate = $VBoxContainer/Yaw/Rates/Center.get_number()
	$VBoxContainer/Yaw/RatePlot.max_rate = $VBoxContainer/Yaw/Rates/Max.get_number()
	$VBoxContainer/Yaw/RatePlot.expo = $VBoxContainer/Yaw/Rates/Expo.get_number()

func write_rate_settings():
	RatesSettings.res.pitch_center_rate = $VBoxContainer/Pitch/Rates/Center.get_number()
	RatesSettings.res.pitch_max_rate = $VBoxContainer/Pitch/Rates/Max.get_number()
	RatesSettings.res.pitch_expo = $VBoxContainer/Pitch/Rates/Expo.get_number()

	RatesSettings.res.roll_center_rate = $VBoxContainer/Roll/Rates/Center.get_number()
	RatesSettings.res.roll_max_rate = $VBoxContainer/Roll/Rates/Max.get_number()
	RatesSettings.res.roll_expo = $VBoxContainer/Roll/Rates/Expo.get_number()

	RatesSettings.res.yaw_center_rate = $VBoxContainer/Yaw/Rates/Center.get_number()
	RatesSettings.res.yaw_max_rate = $VBoxContainer/Yaw/Rates/Max.get_number()
	RatesSettings.res.yaw_expo = $VBoxContainer/Yaw/Rates/Expo.get_number()


func load_rate_settings():
	$VBoxContainer/Pitch/Rates/Center.set_number(RatesSettings.res.pitch_center_rate)
	$VBoxContainer/Pitch/Rates/Max.set_number(RatesSettings.res.pitch_max_rate)
	$VBoxContainer/Pitch/Rates/Expo.set_number(RatesSettings.res.pitch_expo)

	$VBoxContainer/Roll/Rates/Center.set_number(RatesSettings.res.roll_center_rate)
	$VBoxContainer/Roll/Rates/Max.set_number(RatesSettings.res.roll_max_rate)
	$VBoxContainer/Roll/Rates/Expo.set_number(RatesSettings.res.roll_expo)

	$VBoxContainer/Yaw/Rates/Center.set_number(RatesSettings.res.yaw_center_rate)
	$VBoxContainer/Yaw/Rates/Max.set_number(RatesSettings.res.yaw_max_rate)
	$VBoxContainer/Yaw/Rates/Expo.set_number(RatesSettings.res.yaw_expo)
