extends Node3D
@onready var main = $"."

func spawnPlatform(platform_position: Vector3) -> Vector3:
	var platform_scene = preload("res://scenes/platform.tscn")
	var platform = platform_scene.instantiate()
	platform.position = platform_position
	print("Platform: " + str(platform.position))
	add_child(platform)
	return platform.position	
	
func calcNewPosition(prev_position: Vector3, difficulty: int):
	var next_x = randi_range(0, difficulty) + 0.5
	var next_y = prev_position.y + 1
	var next_z = randi_range(0, difficulty) + 0.5
	
	var next_position = Vector3(
		next_x,
		next_y,
		next_z
	)
	
	return next_position

func spawnPlatforms(amount: int, difficulty: int):
	var next_position = Vector3(difficulty, 0, difficulty)
	var prev_position
	
	for i in range(amount):
		prev_position = spawnPlatform(next_position)
		next_position = calcNewPosition(prev_position, difficulty)
	pass
	
func _ready():
	spawnPlatforms(100, 5)
	pass
