extends Control

var dialogue_lines = []
var current_line = 0
var dialogue_active = false

@onready var text_label = $Panel/DialogueText
@onready var next_button = $Panel/NextButton
@onready var portrait = $Panel/CharacterPortrait

func _ready():
	hide()
	next_button.pressed.connect(_on_next_pressed)

func start_dialogue(lines: Array, speaker_texture: Texture):
	dialogue_lines = lines
	current_line = 0
	dialogue_active = true
	portrait.texture = speaker_texture
	show()
	display_line()

func display_line():
	if current_line < dialogue_lines.size():
		text_label.text = dialogue_lines[current_line]
	else:
		close_dialogue()

func close_dialogue():
	dialogue_active = false
	hide()

func _on_next_pressed():
	current_line += 1
	display_line()

func _input(event):
	if dialogue_active and event.is_action_pressed("ui_accept"):
		_on_next_pressed()
