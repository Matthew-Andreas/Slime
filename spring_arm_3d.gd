extends SpringArm3D

var mouse_sensitivityH = 0.005;
var mouse_sensitivityV = 0.005;
@onready var visuals: Node3D = $"../Visuals"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#visuals.rotate_y(-deg_to_rad(event.relative.x*0.5))
		rotation.y -= event.relative.x * mouse_sensitivityH
		rotation.y = wrapf(rotation.y,0.0,TAU)
		
		rotation.x -= event.relative.y * mouse_sensitivityV
		rotation.x = clamp(rotation.x,-PI/3,PI/8)
