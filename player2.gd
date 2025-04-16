extends CharacterBody3D

#@onready var camera_mount: Node3D = $"Camera Mount"
@onready var slime: Node3D = $Visuals/Slime_glb
@onready var visuals: Node3D = $Visuals
@onready var camera: Camera3D = $SpringArm3D/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 6
var somethingHappened = false
var jumping = false
var sense_horizontal = 0.2
var sense_vertical = 0.2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if(event is InputEventMouseMotion):
		#rotate_y(deg_to_rad(-event.relative.x*sense_horizontal))
		#visuals.rotate_y(deg_to_rad(event.relative.x*sense_horizontal))
		#camera_mount.rotate_x(deg_to_rad(-event.relative.y)*sense_vertical)
		pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		somethingHappened = true
	else:
		jumping = false

		# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		slime.animationType("Jump_Move")
		velocity.y = JUMP_VELOCITY
		jumping = true
		somethingHappened = true
		
	if Input.is_action_just_pressed("emote 1") and is_on_floor():
		slime.animationType("Emote_Anger")
		somethingHappened = true
		
	if Input.is_action_just_pressed("emote 2") and is_on_floor():
		slime.animationType("Emote_Sad")
		somethingHappened = true
		
	if Input.is_action_just_pressed("emote 3") and is_on_floor():
		slime.animationType("Emote_Excite")
		somethingHappened = true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "foward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	if direction:
		
		visuals.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if(!jumping):	
			slime.animationType("Scoot_Move")
		#if(!jumping and direction.z<0):
		#	slime.animationType("Scoot_Move")
		#elif(!jumping and direction.z>0):
		#	slime.animationType("back_Scoot_Move")
			
		somethingHappened = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	move_and_slide()
	
	if(!somethingHappened):
		#slime.animationType("Idle")
		somethingHappened = false
	else:
		somethingHappened = false
