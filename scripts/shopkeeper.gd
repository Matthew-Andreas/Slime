extends Node3D

@export var dialogue_resource: DialogueResource  # assign this in the inspector
var player_in_range = false
var dialogue_finished = false  # Track when dialogue ends
var isInteracting = false
@onready var shop_interaction = $Mushroom_red_cartoon/ShopInteractionArea
#@onready var shop_interaction = get_node("Mushroom_red_cartoon/ShopInteraction")
#@onready var dialogue_box = $DialogueBox

var main_scene = null


@onready var label = $Mushroom_red_cartoon/InteractionHint
#@export var upgrade_type: String = "speed"
#@export var cost: int = 10

var player = null
var purchased = false

var resource_path = "res://dialogue/shopkeeper.dialogue"  


@onready var shop_ui = $ShopUI
#@onready var powerup_1_button = $ShopUI/ShopPanel/OptionBox/Powerup_1
#@onready var powerup_2_button = $ShopUI/ShopPanel/OptionBox/Powerup_2
#@onready var powerup_3_button = $ShopUI/ShopPanel/OptionBox/Powerup_3
#@onready var exit_button = $ShopUI/ShopPanel/OptionBox/Exit
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.visible = false
	set_process(true)
	#print(get_node("ShopUI"))  # Should not be null
	shop_ui.visible = false  # Hide shop on start
	shop_interaction.connect("body_entered", _on_body_entered)
	shop_interaction.connect("body_exited", _on_body_exited)

	main_scene = get_tree().get_root().get_node("Main")  


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
			#label.text = "Press [E] to buy " + upgrade_type + " (" + str(cost) + " gems)"

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
#func _on_dialogue_ended(arg):
	#isInteracting = false #this will allow user to keep interacting 
	#print("Dialogue ended with argument:", arg)
##
	## Add custom logic to check if the dialogue has reached its expected end point
	#if "shop_options" in arg.titles:
		#print("Dialogue reached 'shop_options'")
		#show_shop()
	#else:
		#print("Dialogue not yet finished, or unexpected argument:", arg)
func _on_dialogue_ended(arg):
	isInteracting = false
	print("Dialogue ended with argument:", arg)

	if "shop_options" in arg.titles:
		show_shop()
	elif "apply_speed" in arg.titles:
		apply_speed_boost()
	elif "apply_double_jump" in arg.titles:
		apply_double_jump()
		main_scene.update_money_ui()
	elif "apply_jump" in arg.titles:
		apply_jump_boost()
	elif "apply_fall_resist" in arg.titles:
		apply_fall_resistance()
	elif "apply_float" in arg.titles:
		apply_floaty_fall()
	else:
		print("Dialogue not yet finished, or unexpected argument:", arg)



func show_shop():
	shop_ui.visible = true
	#get_tree().paused = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
func close_shop():
	shop_ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func apply_speed_boost():
	if main_scene.player_money >= 5:
		main_scene.player_money -= 5
		main_scene.slimeSpeed = 2
		main_scene.update_money_ui()
		print("Speed Boost purchased!")
		
		#timer
		await get_tree().create_timer(30).timeout
		main_scene.slimeSpeed = 1.0
		print("Speed Boost expired!")
	else:
		print("Not enough gems for Speed Boost!")

func apply_double_jump():
	if main_scene.player_money >= 10:
		main_scene.player_money -= 10
		main_scene.hasDoubleJump = true
		main_scene.update_money_ui()
		print("Double Jump purchased!")
		
		#timer for powerup
		await get_tree().create_timer(30).timeout
		main_scene.hasDoubleJump = false
		print("Double Jump expired!")
	else:
		print("Not enough gems for Double Jump!")

func apply_jump_boost():
	if main_scene.player_money >= 10:
		main_scene.player_money -= 10
		main_scene.slimeGoBoing = 1.5
		main_scene.update_money_ui()
		print("Jump Boost purchased!")
		
		await get_tree().create_timer(30).timeout
		main_scene.slimeGoBoing = 1.0
		print("Jump Boost expired!")
	else:
		print("Not enough gems for Jump Boost!")

func apply_fall_resistance():
	if main_scene.player_money >= 7:
		main_scene.player_money -= 7
		main_scene.lessFallDamage = 3
		main_scene.update_money_ui()
		print("Fall Damage Resistance purchased!")
		
		# Set a timer to reset fall resistance after 30 seconds
		await get_tree().create_timer(30).timeout
		
		
		main_scene.lessFallDamage = 0
		print("Fall Damage Resistance expired!")
	else:
		print("Not enough gems for Fall Resistance!")

func apply_floaty_fall():
	if main_scene.player_money >= 8:
		main_scene.player_money -= 8
		main_scene.fallSpeed = 0.8
		main_scene.update_money_ui()
		print("Floaty Fall purchased!")
		
		# Set a timer to reset floaty fall after 30 seconds
		await get_tree().create_timer(30).timeout
		
		# Reset fall speed to normal
		main_scene.fallSpeed = 1.0
		print("Floaty Fall expired!")
	else:
		print("Not enough gems for Floaty Fall!")



func get_player():
	return get_node("/root/Main/Player")

func _on_exit_pressed():
	close_shop()
