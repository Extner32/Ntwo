@tool
extends HBoxContainer

@export var description := "":
	set(new_text):
		description = new_text
		$DescriptionLabel.text = new_text

@export var slider_min := 0.0:
	set(new_value):
		slider_min = new_value
		$HSlider.min_value = new_value
		
@export var slider_max := 1.0:
	set(new_value):
		slider_max = new_value
		$HSlider.max_value = new_value

@export var slider_value_suffix := "":
	set(new_text):
		slider_value_suffix = new_text
		update_slider_value_label_text(slider_value)

var slider_value := 0.0:
	set(new_value):
		slider_value = new_value
		$HSlider.value = new_value
		update_slider_value_label_text(new_value)

signal value_changed(new_value:float)

func _ready() -> void:
	$HSlider.min_value = slider_min
	$HSlider.max_value = slider_max
	update_slider_value_label_text($HSlider.value)


func _on_h_slider_value_changed(value: float) -> void:
	slider_value = value
	value_changed.emit(value)

func update_slider_value_label_text(value: float):
	$SliderValueLabel.text = str(value)+slider_value_suffix
