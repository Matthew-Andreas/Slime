extends Node3D

var animationSlime: AnimationPlayer

func _ready() -> void:
	animationSlime = get_node("AnimationPlayer")


func animationType(move):
	
	match move:
		"Idle":
			animationSlime.play(move)
		"Scoot_Move":
			animationSlime.play(move)
		"Jump_Move":
			animationSlime.play(move)
		"back_Scoot_Move":
			animationSlime.play_backwards("Scoot_Move")
		"Emote_Anger":
			animationSlime.play(move)
		"Emote_Excite":
			animationSlime.play(move)
		"Emote_Sad":
			animationSlime.play(move)

func get_cur_ani():
	return animationSlime.get_current_animation()
	
func stop_Ani():
	animationSlime.stop()
