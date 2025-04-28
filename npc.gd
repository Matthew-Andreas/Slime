extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		var new_pos = Vector3(self.position.x,self.position.y+0.200,self.position.z);
		self.position = new_pos;
	pass # Replace with function body.

	
func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		var new_pos = Vector3(self.position.x,self.position.y-0.200,self.position.z);
		self.position = new_pos;
	pass # Replace with function body.
