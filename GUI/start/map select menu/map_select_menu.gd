extends MarginContainer




func _ready() -> void:
	load_maps(MapManager.MAP_DIRECTORY)
	
	
	
func load_maps(directory:String):
	for subdir in DirAccess.get_directories_at(directory):
		load_map(directory+subdir)
	
	
func load_map(directory:String):
	MapManager.maps.append(directory)
	
	var map_tile = preload("res://GUI/start/map select menu/map_tile.tscn").instantiate()
	$VBoxContainer/ScrollContainer/Maps.add_child(map_tile)
	map_tile.map_directory = directory
	
	var mapicon_path = directory.path_join("mapicon.png")
	if FileAccess.file_exists(mapicon_path):
		map_tile.map_image = load(mapicon_path)
	
