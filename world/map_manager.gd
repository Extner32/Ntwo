extends Node

var maps := []

var current_map = ""

const MAP_DIRECTORY = "res://world/maps/"
const MAP_DIRECTORY_USER = "user://maps/"


func set_map(map_directory):
	get_tree().change_scene_to_file("res://world/World.tscn")
	current_map = map_directory
