extends Control

var _is_paused:bool = false:
	set = set_paused
	

@onready var options_menu = preload("res://scenes/options_button.tscn")

func _ready() -> void:
	set_paused(false)

func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("pause"):
			_is_paused = !_is_paused


func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	
	if _is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed() -> void:
	_is_paused = false

func _on_options_pressed() -> void:
	var options_instance = options_menu.instantiate()
	get_parent().add_child(options_instance)
	options_instance.set_pause_menu(self)
	set_paused(false)
	options_instance.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()
