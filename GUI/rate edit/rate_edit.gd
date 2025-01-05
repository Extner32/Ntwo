extends HBoxContainer

@export var graph_color:Color = Color(1, 0, 0)
@export var background_color:Color = Color(0, 0, 0, 0)

@export var center_rate_default:int
@export var max_rate_default:int
@export var expo_default:float

@onready var rate_plot: ColorRect = $RatePlot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	write_default()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rate_plot.material.set_shader_parameter("graph_color", graph_color)
	rate_plot.material.set_shader_parameter("background_color", background_color)
	
	rate_plot.material.set_shader_parameter("center_rate", $Rates/Center.get_number())
	rate_plot.material.set_shader_parameter("max_rate", $Rates/Max.get_number())
	rate_plot.material.set_shader_parameter("expo", $Rates/Expo.get_number())

func write_default():
	$Rates/Center.fallback_number = center_rate_default
	$Rates/Center.write_fallback()
	$Rates/Max.fallback_number = max_rate_default
	$Rates/Max.write_fallback()
	$Rates/Expo.fallback_number = expo_default
	$Rates/Expo.write_fallback()
