extends Node3D

@export var dialogue_resource: DialogueResource  # assign this in the inspector
var player_in_range = false
var dialogue_finished = false  # Track when dialogue ends
var isInteracting = false
@onready var shop_interaction = $Mushroom_red_cartoon/ShopInteractionArea
#@onready var shop_interaction = get_node("Mushroom_red_cartoon/ShopInteraction")
#@onready var dialogue_box = $DialogueBox


@onready var label = $Mushroom_red_cartoon/InteractionHint
@export var upgrade_type: String = "speed"
@export var cost: int = 10

var player = null
var purchased = false

var resource_path = "res://dialogue/shopkeeper.dialogue"  


@onready var shop_ui = $ShopUI
@onready var powerup_1_button = $ShopUI/ShopPanel/OptionBox/Powerup_1
@onready var powerup_2_button = $ShopUI/ShopPanel/OptionBox/Powerup_2
@onready var powerup_3_button = $ShopUI/ShopPanel/OptionBox/Powerup_3
@onready var exit_button = $ShopUI/ShopPanel/OptionBox/Exit
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.visible = false
	set_process(true)
	#print(get_node("ShopUI"))  # Should not be null
	shop_ui.visible = false  # Hide shop on start
	shop_interaction.connect("body_entered", _on_body_entered)
	shop_interaction.connect("body_exited", _on_body_exited)

	# Connect buttons
	#powerup_1_button.pressed.connect(_on_powerup_1_pressed)
	#powerup_2_button.pressed.connect(_on_powerup_2_pressed)
	#powerup_3_button.pressed.connect(_on_powerup_3_pressed)
	#exit_button.pressed.connect(_on_exit_pressed)

	# Optional: Connect to dialogue finished signal (if your DialogueManager supports it)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_body_entered(body):
	#if body.is_in_group("Player"):
		#player_in_range = true
		if body.name == "Player":
			animation_player.play("ShopKeeper-Popup")
			player = body
			player_in_range = true
			label.visible = true
			label.text = "Press [E] to buy " + upgrade_type + " (" + str(cost) + " gems)"

func _on_body_exited(body):
	#if body.is_in_group("Player"):
		#player_in_range = false
		#animation_player.play_backwards("ShopKeeper-Popup")
	if body.name == "Player":
		animation_player.play_backwards("ShopKeeper-Popup")
		player_in_range = false
		label.visible = false
		player = null

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialogue_resource and not isInteracting:
			isInteracting = true
			DialogueManager.show_dialogue_balloon(dialogue_resource)
	

#func _on_dialogue_ended():
	#show_shop()
func _on_dialogue_ended(arg):
	isInteracting = false #this will allow user to keep interacting 
	# Handle the argument passed by the signal
	# Add custom logic based on the titles
	# Handle the argument passed by the signal
	# Check if the dialogue has truly ended before showing the shop
	print("Dialogue ended with argument:", arg)
#
	# Add custom logic to check if the dialogue has reached its expected end point
	if "shop_options" in arg.titles:
		print("Dialogue reached 'shop_options'")
		#get_tree().paused = true  # Pause the game to show the shop
		show_shop()
	else:
		print("Dialogue not yet finished, or unexpected argument:", arg)
	#show_shop()
	#print("Dialogue ended with argument:", arg)
	# Your logic for what happens when the dialogue ends

#func _on_dialogue_ended(arg):
	#print("Dialogue ended with argument:", arg)
	#if "shop_options" in arg.titles:
		#print("Dialogue reached 'shop_options'")
		#show_shop()
	#elif "I'll take the speed boost!" in arg.text:
		#print("Player chose speed bost")
		#_on_powerup_2_pressed() #speed boost
	#elif "I'll try the double jump" in arg.text:
		#print("Player chose double jump")
		#_on_powerup_3_pressed() #double jump
	#elif "I think I'm good." in arg.text:
		#print("Player declined purchase")
	#else:
		#print("Dialogue not yet finished or expected:", arg)

func apply_speed_boost():
	var player = get_player()
	if player.gems >= 15:
		player.gems -= 15
		player.speed += 2
		print("Bought Speed Boost")
	else:
		print("Not enough gems")
		
func apply_double_jump():
	var player = get_player()
	if player.gems >= 20:
		player.gems -= 20
		player.jump_power += 3
		print("Bought Double Jump")
	else:
		print("Not enough gems")

func show_shop():
	shop_ui.visible = true
	#get_tree().paused = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
func close_shop():
	shop_ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	




# Replace this with the correct player path if needed!
func get_player():
	return get_node("/root/Main/Player2")

func _on_powerup_1_pressed():
	var player = get_player()
	if player.gems >= 10:
		player.gems -= 10
		player.health += 1
		print("Bought Powerup 1")
		close_shop()
	else:
		print("Not enough gems")

func _on_powerup_2_pressed():
	var player = get_player()
	if player.gems >= 15:
		player.gems -= 15
		player.speed += 2
		print("Bought Powerup 2")
		close_shop()
	else:
		print("Not enough gems")

func _on_powerup_3_pressed():
	var player = get_player()
	if player.gems >= 20:
		player.gems -= 20
		player.jump_power += 5
		print("Bought Powerup 3")
		close_shop()
	else:
		print("Not enough gems")

func _on_exit_pressed():
	close_shop()
