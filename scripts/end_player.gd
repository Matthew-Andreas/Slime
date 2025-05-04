extends Node3D

@export var dialogue_resource: DialogueResource  # assign this in the inspector
var player_in_range = false
var dialogue_finished = false  # Track when dialogue ends
var isInteracting = false

var resource_path = "res://dialogue/end.dialogue"

func _ready() -> void:
	pass
	#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	
func _process(_delta) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialogue_resource and not isInteracting:
			isInteracting = true
			DialogueManager.show_dialogue_balloon(dialogue_resource)



func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		player_in_range = true

	#pass # Replace with function body.





func _on_area_3d_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
