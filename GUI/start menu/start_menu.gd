extends Control


func _on_sandbox_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world/World.tscn")
