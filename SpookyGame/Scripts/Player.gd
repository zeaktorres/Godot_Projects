extends CharacterBody3D
class_name Player

# How fast the player moves in meters per second.
@export var SPEED = 4
@export var health = 100

signal level_won

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

# INSIDE OF PLAYER
@onready var nav_agent = $NavigationAgent3D
@onready var animation_tree = $AnimationTree
var healthBar: HealthBar

# OUTSIDE OF PLAYER
var target: Vector3
var intended_velocity
var gridMap: GridPath
var cell: Cell
var can_change_targets: bool
var rng = RandomNumberGenerator.new()

signal player_hit

enum {RUNNING, WALKING, IDLE}

func setupHealth(newHealth):
	health = newHealth
	healthBar.init_health(health)

func _ready():
	gridMap = get_node("/root/LevelPicker/World/NavigationRegion3D/GridMap")
	healthBar = get_node("/root/LevelPicker/World/WaveContainer/Health/HealthBar")
	

func getNextPosition() -> Vector3:
	var freeCells = gridMap.getFreeCells()
	var randomCell = rng.randi_range(0, freeCells.size() - 1)
	cell = freeCells[randomCell]
	var rayOrigin = global_position
	var space_state = get_world_3d().direct_space_state 
	
	var rayEnd = Vector3(freeCells[randomCell].pos.x + 0.5, freeCells[randomCell].pos.y + 1.5, freeCells[randomCell].pos.z + 0.5)
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = space_state.intersect_ray(query)
	
	return Vector3(freeCells[randomCell].pos.x + 0.5, freeCells[randomCell].pos.y + 1.5, freeCells[randomCell].pos.z + 0.5)
	
		
func changeTarget():
	if can_change_targets:
		target = getNextPosition()
		can_change_targets = false

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO
	# Navigation Agent
	nav_agent.set_target_position(target)
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = next_nav_point - global_transform.origin
	look_at(Vector3(target.x, global_position.y, target.z), Vector3.UP)
	
	# TODO: Handle the delta usecase?
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	if (nav_agent.is_target_reached() || position.distance_squared_to(target) < 4.2):
		target = getNextPosition()
	
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
	print(health)
	health -= 5
	if health > 0:
		healthBar.health = health
	else:
		healthBar.health = 0
		emit_signal("level_won")
	pass
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#move_and_slide()
	pass


func _on_timer_timeout():
	can_change_targets = true
	pass # Replace with function body.
