extends Node2D

func _ready():
	# Connect button signals
	$MenuButtons/PLAY.pressed.connect(_on_play_pressed)
	$MenuButtons/OPTIONS.pressed.connect(_on_options_pressed)
	$MenuButtons/QUIT.pressed.connect(_on_quit_pressed)
	
	# Start animations
	$LogoAnimationPlayer.play("logo_bounce")
	$SlimeAnimationPlayer.play("slime_idle")
	$GemsAnimationPlayer.play("gems_float")

func _on_play_pressed():
	# Change to game scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options_pressed():
	print("Options pressed")
	# Change to options scene
	get_tree().change_scene_to_file("res://scenes/options_button.tscn")

func _on_quit_pressed():
	# Quit the game
	#pass
	get_tree().quit()
