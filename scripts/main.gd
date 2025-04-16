extends Node3D
@onready var main = $"."

func _ready():
	var heart_scene = preload("res://scenes/platform.tscn")
	
	var hearts = []
	
	for i in range(50):
		var heart = heart_scene.instantiate()
		heart.position = Vector3(randi() % 9, randi() % 9, randi() % 9)
		print("Platform: " + str(i) + " " + str(heart.position))
		hearts.append(heart)
		add_child(hearts[i])
