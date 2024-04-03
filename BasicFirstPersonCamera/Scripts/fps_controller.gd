extends CharacterBody3D

@onready var anim_player = $AnimationPlayer

@export var MOUSE_SENSITIVITY : float = 0.2
@export var CONTROLLER_SENSITIVITY : float = 5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var pistol: Node3D
var rootNode: World
var _mouse_rotation : Vector3
var _mouse_input: bool = false
var _rotation_input: float
var _tilt_input: float
var _camera_rotation : Vector3
var _player_rotation : Vector3
var pelletScene = load("res://Scenes//pellet.tscn")
var pelletInstance: Pellet
var multiplayer_id: int = 0
var boolSetup: bool = false
@export var rayCast: RayCast3D
#var _controller_input: bool = false


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func play_shoot_effects():
	# Anim player
	anim_player.stop()
	anim_player.play("shoot")

	pelletInstance = pelletScene.instantiate()
	pelletInstance.position = Vector3(pistol.global_position.x, pistol.global_position.y, pistol.global_position.z)
	pelletInstance.emitting = true
	var farPoint = rayCast.global_position + (rayCast.global_basis * Vector3.FORWARD * 100)
	pelletInstance.direction = (pelletInstance.position.direction_to(farPoint))
	#rootNode.add_child(pelletInstance)
	pass

func _input(event):
	if not is_multiplayer_authority(): return
	
	if event.is_action_pressed("shoot") \
		&& anim_player.current_animation != "shoot":
		play_shoot_effects()
		

func _unhandled_input(event):
	if multiplayer_id != get_multiplayer_authority(): return
	
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
func _update_camera(delta):
	
	
	if _rotation_input == 0 && _tilt_input == 0:
		#controller look	
		var look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		_rotation_input = -look_dir.x * CONTROLLER_SENSITIVITY
		_tilt_input = -look_dir.y * CONTROLLER_SENSITIVITY
	
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	_rotation_input = 0
	_tilt_input = 0
		

func _enter_tree():
	rootNode = get_parent()
	set_multiplayer_authority(multiplayer_id)
	get_tree().root.title += str(multiplayer_id)
	CAMERA_CONTROLLER.current = true


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	_update_camera(delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if anim_player.current_animation == "shoot":
		pass

	elif input_dir != Vector2.ZERO and is_on_floor():
		anim_player.play("move")
	else:
		anim_player.play("idle")
	

	move_and_slide()

