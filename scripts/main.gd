extends Node3D

@export var platform_count = 100
@export var platform_difficulty = 2
@export var heart_rate: float = 0.3
@export var player_health = 3

var platform_positions: Array

var current_player_height: float

func set_player_height(player_height: float):
	if player_height <= current_player_height - 10:
		player_health -= 1

	current_player_height = player_height
	
	print(player_health)
func spawnScene(
	scene_position: Vector3,
	scene_resource: Resource,
	scene_scale: Vector3 = Vector3(1, 1, 1)
) -> Vector3:
	
	var scene = scene_resource.instantiate()
	
	scene.position = scene_position
	scene.scale = scene_scale
	add_child(scene)
	
	return scene.position	

func nextPlatformPosition(prev_position: Vector3, difficulty: int):
	var next_x = randi_range(0 - (difficulty/2), difficulty - (difficulty/2)) #- 0.5
	var next_y = prev_position.y + 1
	var next_z = randi_range(0 - (difficulty/2), difficulty - (difficulty/2)) #- 0.5
	
	var next_position = Vector3(next_x, next_y, next_z)
	
	return next_position

func spawnPlatforms():
	var platform_scene = preload("res://scenes/platform.tscn")
	var next_platform_position = Vector3(
		0,
		0,
		0
	)
	var prev_platform_position
	
	# Spawn Platforms
	for i in range(platform_count):
		platform_positions.append(next_platform_position)
		
		prev_platform_position = spawnScene(
			next_platform_position, 
			platform_scene
		)
		
		next_platform_position = nextPlatformPosition(
			prev_platform_position,
			platform_difficulty
		)
	
func spawnItem(item_scene: Resource, item_rate: float, item_name: String):
	var item_cnt = ceil(platform_count * (item_rate / platform_difficulty))
	var next_item = floor(platform_count / item_cnt)
	print(item_name + "s: " + str(item_cnt))
	print("1 " + item_name + " after every " + str(next_item) + " platforms.")
	
	var next_heart_position = platform_positions[0]
	next_heart_position.y += 0.25

	for i in range(platform_positions.size()):
		if i == next_item and item_cnt > 0:
			spawnScene(
				next_heart_position, 
				item_scene,
				Vector3(0.5, 0.5, 0.5)
			)
				
			next_heart_position = platform_positions[i]
			next_heart_position.y += 0.25
			
			item_cnt -= 1
			next_item *= 2
	
func _ready():
	spawnPlatforms()
	
	spawnItem(preload("res://scenes/heart.tscn"), 0.3, "heart")
