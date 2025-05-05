extends Control

func _ready():
	# Start with everything invisible
	#modulate.a = 0
	# Play the fade-in animation after a short delay
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("fade_in")
	show_ending_screen(GameManager.calcScore(),GameManager.format_seconds(GameManager.time_elapsed, false),"0/10","99")

# Function to be called when the level is completed
func show_ending_screen(score, time, collectibles, accuracy):
	# Updates the stats with the actual player data
	$StatsPanel/TimeValue.text = str(time)
	$StatsPanel/CollectiblesValue.text = collectibles
	$StatsPanel/AccuracyValue.text = str(accuracy) + "%" #we dont have to have this one
	$StatsPanel/ScoreValue.text = str(score)
	
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
