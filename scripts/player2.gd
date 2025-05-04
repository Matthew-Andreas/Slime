extends CharacterBody3D

#@onready var camera_mount: Node3D = $"Camera Mount"
@onready var slime: Node3D = $Visuals/Slime_glb
@onready var visuals: Node3D = $Visuals
@onready var camera: Camera3D = $SpringArm3D/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 6
var somethingHappened = false
var isEmoting = false
var jumping = false
var doublejumping = false
var sense_horizontal = 0.2
var sense_vertical = 0.2
var mouse_captured : bool = false

#for shopkeeper npc
var can_interact_with_shopkeeper = false
var current_shopkeeper: Node = null
#var speed: float = 5.0
#var jump_power: float = 6.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#for shopkeeper
	add_to_group("Player")  #this line makes your player detectable

func _input(event):
	if(event is InputEventMouseMotion):
		#rotate_y(deg_to_rad(-event.relative.x*sense_horizontal))
		#visuals.rotate_y(deg_to_rad(event.relative.x*sense_horizontal))
		#camera_mount.rotate_x(deg_to_rad(-event.relative.y)*sense_vertical)
		pass

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if(slime.get_cur_ani() == "Emote_Anger" or slime.get_cur_ani() == "Emote_Excite" or slime.get_cur_ani() == "Emote_Sad"):
		somethingHappened = true
		isEmoting = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		somethingHappened = true
		isEmoting = false
	else:
		jumping = false
		doublejumping = false
		GameManager.set_player_height(self.position.y)
		
		# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		slime.animationType("Jump_Move")
		velocity.y = JUMP_VELOCITY
		jumping = true
		somethingHappened = true
		isEmoting = false
		
	if Input.is_action_just_pressed("jump") and not is_on_floor() and GameManager.hasDoubleJump and not doublejumping:
		slime.stop_Ani()
		slime.animationType("Jump_Move")
		velocity.y = JUMP_VELOCITY
		jumping = true
		doublejumping = true
		somethingHappened = true
		isEmoting = false
		
	if Input.is_action_just_pressed("emote 1") and is_on_floor():
		slime.animationType("Emote_Anger")
		somethingHappened = true
		
		
	if Input.is_action_just_pressed("emote 2") and is_on_floor():
		slime.animationType("Emote_Sad")
		somethingHappened = true
		
	if Input.is_action_just_pressed("emote 3") and is_on_floor():
		slime.animationType("Emote_Excite")
		somethingHappened = true
	
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	if direction:
		isEmoting = false
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
	
	if(!somethingHappened and !isEmoting):
		slime.animationType("Idle")
	somethingHappened = false
		
	
