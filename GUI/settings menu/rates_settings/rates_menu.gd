extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Pitch.center_rate_default = rad_to_deg(Controller.pitch_center_rate)
	$VBoxContainer/Pitch.max_rate_default = rad_to_deg(Controller.pitch_max_rate)
	$VBoxContainer/Pitch.expo_default = Controller.pitch_expo
	$VBoxContainer/Pitch.write_default()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
