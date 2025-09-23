extends MarginContainer

func _ready():
	$ScrollContainer/VBoxContainer/Graphics/PanelContainer/ResolutionScaleSlider.slider_value = SimulatorSettings.get_property("resolution_scale")
	


func _on_resolution_scale_slider_value_changed(new_value: float) -> void:
	SimulatorSettings.set_property("resolution_scale", new_value)
