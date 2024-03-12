extends CharacterBody3D
class_name Player

# How fast the player moves in meters per second.
@export var SPEED = 4

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

# INSIDE OF PLAYER
@onready var nav_agent = $NavigationAgent3D
@onready var animation_tree = $AnimationTree

# OUTSIDE OF PLAYER
var target: Vector3
var gridMap: GridPath
var cell: Cell
var rng = RandomNumberGenerator.new()

signal player_hit

enum {RUNNING, WALKING, IDLE}

func _ready():
	gridMap = get_node("/root/World/NavigationRegion3D/GridMap")

func getNextPosition() -> Vector3:
	var freeCells = gridMap.getFreeCells()
	if cell == null:
		var randomCell = rng.randi_range(0, freeCells.size() - 1)
		cell = freeCells[randomCell]
		return Vector3(freeCells[randomCell].pos.x + 0.5, freeCells[randomCell].pos.y + 1.5, freeCells[randomCell].pos.z + 0.5)
	if position.distance_squared_to(cell.pos) > 40:
		return Vector3(cell.pos.x + 0.5, cell.pos.y + 1.5, cell.pos.z + 0.5)
		
	# Find new cell
	var farthestCellDistance = position.distance_squared_to(cell.pos)
	var farCells = []
	if freeCells.size() > 0:
		for newCell in freeCells:
			if position.distance_squared_to(newCell.pos) > 40:
				farCells.append(newCell)
	
	if farCells.size() > 0:
		var randomCell = rng.randi_range(0, farCells.size() - 1)
		cell = farCells[randomCell]
		return Vector3(farCells[randomCell].pos.x + 0.5, farCells[randomCell].pos.y + 1.5, farCells[randomCell].pos.z + 0.5)
	else:
		var randomCell = rng.randi_range(0, freeCells.size() - 1)
		cell = freeCells[randomCell]
		return Vector3(freeCells[randomCell].pos.x + 0.5, freeCells[randomCell].pos.y + 1.5, freeCells[randomCell].pos.z + 0.5)
		
		
func changeTarget():
	target = getNextPosition()

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
	print(position.distance_squared_to(target))
	if (nav_agent.is_target_reached() || position.distance_squared_to(target) < 4.2):
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
