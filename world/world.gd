extends Node3D

func _ready():
	gb.world_ref = self
	set_map(MapManager.current_map)

func _process(delta: float) -> void:
	$SubViewportContainer.stretch_shrink = 1.0/SimulatorSettings.get_property("resolution_scale")

func set_map(map_directory:String):
	var map_name = map_directory.get_basename().split("/")[-1]
	var scene_path = map_directory.path_join(map_name+".tscn")
	if FileAccess.file_exists(scene_path):
		var map = load(scene_path).instantiate()
		$SubViewportContainer/SubViewport/Map.add_child(map)
