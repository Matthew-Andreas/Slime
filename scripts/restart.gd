extends Button

func _ready():
	# Connect the button's pressed signal to our function
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# In a real game, you'd put code here to restart the level or game
	print("Restart button pressed")
	# Example: get_tree().reload_current_scene()
