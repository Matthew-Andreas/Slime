extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var dialogue_resource: DialogueResource

var player_in_range := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	if player_in_range and Input.is_action_just_pressed("interact"):
			if dialogue_resource:
				DialogueManager.show_dialogue_balloon(dialogue_resource)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		#var new_pos = Vector3(self.position.x,self.position.y+0.200,self.position.z);
		#self.position = new_pos;
		player_in_range = true
		animation_player.play("NPC Pop_up")
	pass # Replace with function body.

	
func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		#var new_pos = Vector3(self.position.x,self.position.y-0.200,self.position.z);
		#self.position = new_pos;
		player_in_range = true
		animation_player.play_backwards("NPC Pop_up")
	pass # Replace with function body.
