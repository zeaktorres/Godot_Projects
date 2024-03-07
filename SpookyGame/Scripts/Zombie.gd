extends CharacterBody3D




@onready var player = $"../Player"
@onready var nav_agent = $NavigationAgent3D
@onready var camera = $"../Camera3D"
@onready var animation_tree = $AnimationTree
@export var SPEED = 3

var direction = Vector3.ZERO
var state_machine

enum {RUNNING, WALKING, IDLE}

func _ready():
	state_machine = animation_tree.get("parameters/playback")

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO

	# Navigation Agent
	nav_agent.set_target_position(player.position)
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = next_nav_point - global_transform.origin
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

	# Move zombie
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
	elif (magnitude < 4):
		return WALKING
	else:
		return RUNNING
		
func _hit_finished():
	player.hit()
