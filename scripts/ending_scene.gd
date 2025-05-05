extends Control

func _ready():
	# Start with everything invisible
	#modulate.a = 0
	# Play the fade-in animation after a short delay
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("fade_in")
	show_ending_screen(GameManager.calcScore(),GameManager.format_seconds(GameManager.time_elapsed, false),GameManager.player_health,"99")
	
	$Restart.pressed.connect(_on_restart_pressed)
	$MainMenuButton.pressed.connect(_on_main_menu_pressed)

# Function to be called when the level is completed
func show_ending_screen(score, time, collectibles, accuracy):
	# Updates the stats with the actual player data
	var score2 = "%02f" % score
	
	$StatsPanel/TimeValue.text = str(time)
	$StatsPanel/CollectiblesValue.text = str(collectibles)
	$StatsPanel/ScoreValue.text = str(score2)
	
	# Calculates rating based on score
	var rating = "C"
	if score > 10000:
		rating = "A+"
	elif score > 8000:
		rating = "A"
	elif score > 6000:
		rating = "B+"
	elif score > 4000:
		rating = "B"
	
	$RatingDisplay.text = rating

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")  

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")  
