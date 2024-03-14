extends CharacterBody3D
class_name Player

# How fast the player moves in meters per second.
@export var speed = 4
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
var can_change_targets: bool = true
var rng = RandomNumberGenerator.new()
var zombiePowerUps: ZombiePowerUps
var playerPowerUps: PlayerPowerUps
@onready var changeTargetsTimer: Timer = $ChangeTargets
@onready var dropMinestimer: Timer = $DropMine
var world: World
var minesLeft: int = 0
var mineScene = load("res://Scenes/Mine.tscn")
var hasWon = false

signal player_hit

enum {RUNNING, WALKING, IDLE}

func setupHealth(newHealth):
	health = newHealth
	healthBar.init_health(health)
	changeTarget()
	minesLeft = playerPowerUps.mineCount
	speed = playerPowerUps.speed
	if playerPowerUps.isReactiveAI:
		changeTargetsTimer.wait_time = 0.1
	if playerPowerUps.spawnMinesFast:	
		dropMinestimer.stop()
		dropMinestimer.wait_time = 1
		dropMinestimer.start()

func _ready():
	gridMap = get_node("/root/LevelPicker/World/NavigationRegion3D/GridMap")
	healthBar = get_node("/root/LevelPicker/World/WaveContainer/Health/HealthBar")
	world = get_node("/root/LevelPicker/World")

func getNextPosition() -> Vector3:
	var freeCells = gridMap.getFreeCells()
	var randomCell = rng.randi_range(0, freeCells.size() - 1)
	cell = freeCells[randomCell]
	
	
	return Vector3(freeCells[randomCell].pos.x + 0.5, freeCells[randomCell].pos.y + 1.5, freeCells[randomCell].pos.z + 0.5)
	
		
func changeTarget():
	if can_change_targets:
		target = getNextPosition()
		can_change_targets = false
		nav_agent.set_target_position(target)
		
func setAnimationTree():
	animation_tree.set("parameters/conditions/isRunning", getState() == RUNNING)
	animation_tree.set("parameters/conditions/isWalking", getState() == WALKING)
	animation_tree.set("parameters/conditions/isIdle", getState() == IDLE)

func _physics_process(delta):
	if (nav_agent.is_target_reached() || position.distance_squared_to(target) < 4.2):
		velocity = Vector3.ZERO
		setAnimationTree()
		can_change_targets = true
		changeTarget()
		return
		
	
	# Navigation Agent
	var next_nav_point = nav_agent.get_next_path_position()
	var direction = next_nav_point - global_transform.origin
	look_at(Vector3(next_nav_point.x, global_position.y, next_nav_point.z), Vector3.UP)
	
	# TODO: Handle the delta usecase?
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	# Determine what state the player is in
	setAnimationTree()
	

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
	health -= zombiePowerUps.damage
	if health > 0:
		healthBar.health = health
	else:
		healthBar.health = 0
		if hasWon == false:
			emit_signal("level_won")
			hasWon = true
	pass
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#move_and_slide()
	pass


func _on_timer_timeout():
	can_change_targets = true
	pass # Replace with function body.

func removeMine(node: Node3D):
	world.remove_child(node)
	node.queue_free()
	pass

func _on_drop_mine_timeout():
	if minesLeft > 0:
		var mineSceneInstance: Mine = mineScene.instantiate()
		world.add_child(mineSceneInstance)
		mineSceneInstance.position = Vector3(position.x, 1, position.z)
		mineSceneInstance.removeMe.connect(removeMine)
		minesLeft -= 1
	pass # Replace with function body.
