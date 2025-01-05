extends HBoxContainer

@export var fallback_number:float
@export var text := ""

func _ready() -> void:
	write_fallback()

func _process(delta: float) -> void:
	$Error.visible = !$LineEdit.text.is_valid_float()
	$Label.text = text

func get_number(fallback=true):
	if $LineEdit.text.is_valid_float():
		return float($LineEdit.text)
	else:
		if fallback:
			return fallback_number
		else:
			return null
			

func write_fallback():
	$LineEdit.text = str(fallback_number)
