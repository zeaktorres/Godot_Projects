extends CharacterBody3D




@onready var player =$"../Child"
@onready var nav_agent = $"Pivot/Zombie/NavigationAgent3D" 
@onready var animation_tree= $"Pivot/Zombie/AnimationTree"
@export var SPEED = 3

var direction = Vector3.ZERO
var state_machine

enum {WALKING, IDLE}

func _ready():
	state_machine = animation_tree.get("parameters/playback")

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO

	# Navigation 
	nav_agent.target_position = player.position
	var next_nav_point = nav_agent.get_next_path_position()
	var move_to_direction = next_nav_point - global_transform.origin
	var look_at_direction = Vector3(move_to_direction.x, 0, move_to_direction.z)
	direction = direction.lerp(look_at_direction.normalized(), delta * 10)
	direction = direction.normalized()
	$Pivot.basis = Basis.looking_at(direction)

	# Move zombie
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	if (global_transform.origin.distance_to(player.position) < 1):
		animation_tree.advance(delta * 0.1)
		animation_tree.set("parameters/conditions/isClose", true)
		print("Here")
	else:
		animation_tree.set("parameters/conditions/isClose", false)
		animation_tree.advance(delta * 3)
		
	if state_machine.get_current_node() == "Attack1":
		velocity = Vector3.ZERO
	print(state_machine.get_current_node())

	# Moving the Character
	move_and_slide()
	
func getState():
	var magnitude = velocity.length()
	if (magnitude == 0):
		return IDLE
	elif (magnitude < 4):
		return WALKING
		
func _hit_finished():
	player.hit()
