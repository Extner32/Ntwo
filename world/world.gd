extends Node3D

func _process(delta: float) -> void:
	$SubViewportContainer.stretch_shrink = 1.0/SimulatorSettings.get_property("resolution_scale")
