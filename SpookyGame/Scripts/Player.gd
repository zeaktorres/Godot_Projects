extends CharacterBody3D

# How fast the player moves in meters per second.
@export var SPEED = 4

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

@onready var target = $"../NavigationRegion3D/Target"
@onready var nav_agent = $NavigationAgent3D
@onready var camera = $"../Camera3D"
@onready var animation_tree = $AnimationTree

signal player_hit

enum {RUNNING, WALKING, IDLE}


func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO

	# Navigation Agent
	nav_agent.set_target_position(target.position)
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = next_nav_point - global_transform.origin
	look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
	
	# TODO: Handle the delta usecase?
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	if (nav_agent.is_target_reached()):
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
	elif (magnitude < 3):
		return WALKING
	else:
		return RUNNING
		
func hit():
	emit_signal("player_hit")
	pass
