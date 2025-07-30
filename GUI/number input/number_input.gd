extends HBoxContainer

@export var fallback_number:float
@export var comment_text := ""

signal changed_to_valid_number(number:float)


func _process(delta: float) -> void:
	$Error.visible = !$LineEdit.text.is_valid_float()
	$Label.text = comment_text

func set_number(value:float):
	$LineEdit.text = str(value)

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


func _on_line_edit_text_changed(new_text: String) -> void:
	if $LineEdit.text.is_valid_float():
		changed_to_valid_number.emit(float($LineEdit.text)) 
	
