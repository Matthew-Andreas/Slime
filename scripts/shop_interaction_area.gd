extends Area3D

signal player_entered_shop
signal player_exited_shop

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_entered_shop")

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal("player_exited_shop")
