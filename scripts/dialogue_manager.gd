extends Node

var dialogue_box_scene = preload("res://scenes/DialogueBox.tscn")
var dialogue_box = null

func _ready():
	dialogue_box = dialogue_box_scene.instantiate()
	get_tree().root.add_child(dialogue_box)
	dialogue_box.hide()

func show_dialogue(lines: Array, speaker_texture: Texture):
	if not dialogue_box.is_inside_tree():
		get_tree().root.add_child(dialogue_box)
	dialogue_box.start_dialogue(lines, speaker_texture)
