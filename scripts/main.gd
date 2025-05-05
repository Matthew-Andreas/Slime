extends Node3D

const SPACE_SKY:Sky = preload("res://Skies/SpaceSky.tres")
const NORMAL_SKY = preload("res://Skies/NormalSky.tres")

@export var player_money: float = 3
var money_label

var time_elapsed := 0.0
var countup_timer

# power ups
# increase number to have player take damage after a bigger fall
# 1 = loosing a heart after 5 platform fall - Default
# 2 = loosing a heart after 10 platform fall
# 3 = loosing a heart after 15 platform fall
# add at underground shop
var lessFallDamage = 1
# True - Double jump active
# False - Double jump not active
# add at ground shop
var hasDoubleJump = false
#increases jump height
# 1 - is normal jump
# 1.05 - lets player skip 1 platform
# 1.5 - makes you super jump
# I would advise adding the 1.5 value in the clouds since it makes the game
# signficantly easier but also kind of hard
var slimeGoBoing = 1
# increase speed of slime
# 1 - normal speed
# 1.5 - little faster
# 2 -almost too fast
# This one could go in any shop 
var slimeSpeed = 1
# slow down fall speed(Also increases jump height)
# 1 - normal gravity
# 0.90 - slightly slower fall and increase jump
# 0.80 - slower fall and increase jump
var fallSpeed = 1

@export var player_health: float = 3
var prev_player_health: float
var player_health_ui: Array

var current_player_height: float

func calcScore():
	var score = (player_health * player_money) / time_elapsed
	print(score)
	return score

func update_money_ui():
	money_label.set_text(" x " + str(player_money))
	pass
	
func update_health_ui():
	if player_health == 0:
		print("Player died")
		if is_instance_valid(player_health_ui[player_health_ui.size() - 1]):
			player_health_ui[player_health_ui.size() - 1].queue_free()
		player_health = -1
	else:
		if prev_player_health > player_health:
			if is_instance_valid(player_health_ui[player_health_ui.size() - 1]):
				player_health_ui[player_health_ui.size() - 1].queue_free()
				player_health_ui.resize(player_health_ui.size() - 1)
			
		if prev_player_health < player_health:
			var texture_rect = TextureRect.new()
			var texture = load("res://2D Gems/heart.png")
			texture_rect.texture = texture
			texture_rect.scale = Vector2(0.075, 0.075)
			var prev_texture_rect = player_health_ui[player_health_ui.size() - 1]
			texture_rect.position = Vector2(prev_texture_rect.position.x + 45, texture_rect.position.y)
			print(texture_rect.position)
			add_child(texture_rect)
			player_health_ui.append(texture_rect) 

func set_player_height(player_height: float):
	if player_height <= current_player_height - (5 * lessFallDamage):
		player_health -= 1

	current_player_height = player_height

func set_player_money(money: float):
	player_money = money

func set_player_health(health: float):
	player_health = health

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
	var next_x: float = randi_range(0 , difficulty * 2)
	var next_y: float = prev_position.y + 1.0
	var next_z: float = randi_range(0 , difficulty * 2)
	
	var next_position = Vector3((next_x/2.0)-(difficulty/2.0), next_y, (next_z/2.0)-(difficulty/2.0))
	
	return next_position

func spawnPlatforms(platform_count: int, platform_difficulty: int, start_position: Vector3) -> Array:
	var platform_positions: Array
	
	var platform_scene = preload("res://scenes/platform.tscn")
	var next_platform_position = start_position
	var prev_platform_position
	
	
	# Spawn Platforms
	for i in range(platform_count):
		platform_positions.append(next_platform_position)
		
		if i % 50 == 0 and i != 0:
			platform_difficulty += 1
		
		prev_platform_position = spawnScene(
			next_platform_position, 
			platform_scene
		)
		
		next_platform_position = nextPlatformPosition(
			prev_platform_position,
			platform_difficulty
		)
	
	return platform_positions
	
func spawnItem(
	item_scene: Resource,
	item_rate: float,
	item_name: String,
	platform_positions: Array,
	platform_count: int
):
	var item_cnt = ceil(platform_count * item_rate)
	var next_item_step = floor(platform_count / item_cnt)
	var next_item = next_item_step
	print(item_name + "s: " + str(item_cnt) + " | 1 " + item_name + " after every " + str(next_item) + " platforms.")
	
	var next_item_position = platform_positions[0]
	next_item_position.x += randf_range(-0.3, 0.3)
	next_item_position.y += 0.25
	next_item_position.z += randf_range(-0.3, 0.3)
	
	var item_scale = Vector3(0.5, 0.5, 0.5)

	for i in range(platform_positions.size()):
		
		if i == next_item and item_cnt > 0:
			
			spawnScene(
				next_item_position, 
				item_scene,
				item_scale
			)
				
			next_item_position = platform_positions[i]
			next_item_position.x += randf_range(-0.3, 0.3)
			next_item_position.y += 0.25
			next_item_position.z += randf_range(-0.3, 0.3)
			
			item_cnt -= 1
			next_item += next_item_step
			
			print("Item position: " + str(next_item_position))
	
func format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]

	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
func _ready():
	countup_timer = Label.new()
	countup_timer.position.y += 100
	add_child(countup_timer)
	
	prev_player_health = player_health
	
	for i in range(prev_player_health):
		var texture_rect = TextureRect.new()
		var texture = load("res://2D Gems/heart.png")
		texture_rect.texture = texture
		texture_rect.scale = Vector2(0.075, 0.075)
		texture_rect.position = Vector2(texture_rect.position.x + i * 45, texture_rect.position.y)
		print(texture_rect.position)
		add_child(texture_rect)
		player_health_ui.append(texture_rect)
	
	money_label = Label.new()
	money_label.set_text(" x " + str(player_money))
	money_label.position = Vector2(money_label.position.x + 40, money_label.position.y + 50)
	money_label.size = Vector2(50, 50)
	add_child(money_label)
	
	var texture_rect = TextureRect.new()
	var texture = load("res://2D Gems/blue gem.png")
	texture_rect.texture = texture
	texture_rect.scale = Vector2(0.15, 0.15)
	texture_rect.position = Vector2(texture_rect.position.x, texture_rect.position.y + 45)
	print(texture_rect.position)
	add_child(texture_rect)
		
	var platform_positions = []
	
	# 0 - 50 platforms
	platform_positions = spawnPlatforms(50, 2, Vector3(0, -0.1, 0))	
	# Hearts
	spawnItem(preload("res://scenes/heart.tscn"), 0.1, "heart", platform_positions, 50)
	# Gem_7s
	spawnItem(preload("res://scenes/gem_7.tscn"), 0.3, "gem_7", platform_positions, 50)
	# Gem_1s
	spawnItem(preload("res://scenes/gem_1.tscn"), 0.9, "gem_1", platform_positions, 50)
	
	# 50 - 100 platforms
	platform_positions = spawnPlatforms(50, 3, Vector3(0, 50, 0))
	# Hearts
	spawnItem(preload("res://scenes/heart.tscn"), 0.075, "heart", platform_positions, 50)
	# Gem_7s
	spawnItem(preload("res://scenes/gem_7.tscn"), 0.8, "gem_7", platform_positions, 50)
	# Gem_1s
	spawnItem(preload("res://scenes/gem_1.tscn"), 0.25, "gem_1", platform_positions, 50)
	
	# 100 - 150 platforms
	platform_positions = spawnPlatforms(50, 4, Vector3(0, 100, 0))
	# Hearts
	spawnItem(preload("res://scenes/heart.tscn"), 0.05, "heart", platform_positions, 50)
	# Gem_7s
	spawnItem(preload("res://scenes/gem_7.tscn"), 0.2, "gem_7", platform_positions, 50)
	# Gem_1s
	spawnItem(preload("res://scenes/gem_1.tscn"), 0.7, "gem_1", platform_positions, 50)
	
	# 150 - 200 platforms
	platform_positions = spawnPlatforms(50, 5, Vector3(0, 150, 0))
	# Hearts
	spawnItem(preload("res://scenes/heart.tscn"), 0.025, "heart", platform_positions, 50)
	# Gem_7s
	spawnItem(preload("res://scenes/gem_7.tscn"), 0.6, "gem_7", platform_positions, 50)
	# Gem_1s
	spawnItem(preload("res://scenes/gem_1.tscn"), 0.15, "gem_1", platform_positions, 50)

func _process(delta: float) -> void:
	time_elapsed += delta
	
	countup_timer.text = format_seconds(time_elapsed, false)
	
	update_health_ui()
	prev_player_health = player_health
	
	update_money_ui()
