extends Button

func _ready():
	# Connect the button's pressed signal to our function
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# In a real game, you'd put code here to go to the main menu
	print("Main Menu button pressed")
	# Example: get_tree().change_scene_to_file("res://MainMenu.tscn")
