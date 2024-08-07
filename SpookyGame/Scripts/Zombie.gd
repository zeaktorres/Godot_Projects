extends CharacterBody3D
class_name Zombie



var player

# INSIDE OF ZOMBIE
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree = $AnimationTree

var speed = 3: set = _set_speed

var direction = Vector3.ZERO
var state_machine
var intended_velocity

enum {RUNNING, WALKING, IDLE}

func _set_speed(newSpeed):
	$NavigationAgent3D.max_speed = newSpeed
	$NavigationAgent3D.target_desired_distance *= scale.x
	speed = newSpeed

func _ready():
	state_machine = animation_tree.get("parameters/playback")
	player = get_node("/root/LevelPicker/World").find_child("Player")
	nav_agent.set_target_position(Vector3(player.position.x, position.y, player.position.z))

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO

	# Move zombie
	
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = next_nav_point - global_transform.origin
	match state_machine.get_current_node():
		"Attack":
			animation_tree.advance(delta * 1.5 * (speed / 3))
			pass
		_:
			intended_velocity = (next_nav_point - global_transform.origin).normalized() * speed
			nav_agent.set_velocity(intended_velocity)
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	if (nav_agent.is_target_reached()):
		intended_velocity = Vector3.ZERO
		animation_tree.set("parameters/conditions/isAttacking", true)
	else:
		# Determine what state the player is in
		animation_tree.set("parameters/conditions/isAttacking", false)
		animation_tree.set("parameters/conditions/isRunning", getState() == RUNNING)
		animation_tree.set("parameters/conditions/isWalking", getState() == WALKING)
		animation_tree.set("parameters/conditions/isIdle", getState() == IDLE)

	# Moving the Character
	move_and_slide()
	
func getState():
	var magnitude = intended_velocity.length()
	if (magnitude == 0):
		return IDLE
	elif (magnitude < 4):
		return WALKING
	else:
		return RUNNING
		
func _hit_finished():
	if (global_position.distance_to(player.global_position) < 1):
		player.hit()

func _arm_hit(body):
	if body.name != "Player":
		return
	if state_machine.get_current_node() == "Attack":
		body.hit()
	pass


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if state_machine.get_current_node() != "Attack":
		velocity = safe_velocity
		move_and_slide()


func _on_change_target_timeout():
	nav_agent.set_target_position(Vector3(player.position.x, position.y, player.position.z))
	pass # Replace with function body.
