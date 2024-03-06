extends CharacterBody3D

# How fast the player moves in meters per second.
@export var SPEED = 5

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

@onready var target = $"../NavigationRegion3D/Target"
@onready var nav_agent = $Pivot/Character/NavigationAgent3D
@onready var camera = $"../Camera3D"
@onready var animation_tree = $Pivot/Character/AnimationTree

enum {RUNNING, WALKING, IDLE}


func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO

	# Navigation Agent
	nav_agent.target_position = target.position
	var next_nav_point = nav_agent.get_next_path_position()
	var move_to_direction = next_nav_point - global_transform.origin
	var look_at_direction = Vector3(move_to_direction.x, 0, move_to_direction.z)
	direction = direction.lerp(look_at_direction.normalized(), delta * 10)
	direction = direction.normalized()
	$Pivot.basis = Basis.looking_at(direction)
	
	# TODO: Handle the delta usecase?
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	# Stop when reaching goal		
	if (global_transform.origin.distance_to(target.position) < 1.5):
		velocity = Vector3.ZERO
	
	# Determine what state the player is in
	animation_tree.set("parameters/conditions/isRunning", getState() == RUNNING)
	animation_tree.set("parameters/conditions/isWalking", getState() == WALKING)
	animation_tree.set("parameters/conditions/isIdle", getState() == IDLE)
	

	# Moving the Character
	move_and_slide()
	
func getState():
	var magnitude = velocity.length()
	if (magnitude == 0):
		return IDLE
	elif (magnitude < 4):
		return WALKING
	else:
		return RUNNING
func hit():
	pass
