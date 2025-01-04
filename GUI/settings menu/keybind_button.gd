extends Button

@export var action_name:String = "pitch_up"

var event = null

var last_event = null

var waiting = false

func _ready():
	event = InputMap.action_get_events(action_name)[0]

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		last_event = event


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		text = str(event)


func _on_pressed() -> void:
	print(last_event)
	waiting = true
