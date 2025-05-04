extends Area3D

@onready var heart: Area3D = $"."
var audio_stream_player_3d
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Timer

func _ready() -> void:
	audio_stream_player_3d = AudioStreamPlayer3D.new()
	audio_stream_player_3d.stream = load("res://Audio/Sound Effects/Retro PowerUP StereoUP 05.wav")
	audio_stream_player_3d.bus = "SFX"
	add_child(audio_stream_player_3d)
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and self.visible == true:
		GameManager.set_player_health(
			GameManager.player_health + 1
		)
		
		collision_shape_3d.set_deferred("disable", true)
		self.visible = false
		
		audio_stream_player_3d.play()
		
		timer.start()

func _on_timer_timeout() -> void:
	heart.queue_free()
