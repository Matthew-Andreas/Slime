extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		GameManager.set_player_money(
			GameManager.player_money + 1
		)
		
		self.queue_free()
