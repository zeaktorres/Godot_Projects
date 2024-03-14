extends Node3D

var mainWorld = load("res://Scenes/World1.tscn")
var shop = load("res://Scenes/Shop.tscn")
var loseScreen = load("res://Scenes/Lose_Screen.tscn")
var winScreen = load("res://Scenes/Win_Screen.tscn")
var mainWorldInstance
var loseScreenInstance
var winScreenInstance
var wave: Wave
var zombiePowerUps: ZombiePowerUps
var playerPowerUps: PlayerPowerUps
var shopInstance 
var player: Player
var loseTimer: Timer
@onready var playerPowerUpsLabel: ItemList = $Control/PlayerPowerUps
var playerPowerUpsList: ItemList
var isEndless: bool = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func setupPowers():
	wave = Wave.new()
	zombiePowerUps = ZombiePowerUps.new()
	playerPowerUps = PlayerPowerUps.new()
	wave.zombiePowerUps = zombiePowerUps
	wave.playerPowerUps = playerPowerUps

func _ready():
	setupPowers()
	setupWorld()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deleteWorld():
	remove_child(mainWorldInstance)
	mainWorldInstance.free()

func deleteShop():
	remove_child(shopInstance)
	shopInstance.free()
	setupWorld()
	
func deleteLoseScreen():
	remove_child(loseScreenInstance)
	loseScreenInstance.free()

func deleteWinScreen():
	remove_child(winScreenInstance)
	winScreenInstance.free()

func upgradePlayer():
	if wave.number <= 11:
		match wave.number:
			1:
				playerPowerUps.health += (100 * (wave.number + (1/4)))
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Increasing Health")
			2:
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Player Obtains Large Mine")
				playerPowerUps.mineCount = 1
			3: 
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Remove 30 seconds")
				playerPowerUps.timer -= 30
			4: 
				playerPowerUps.health += (100 * (wave.number + (1/4)))
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Increasing Health")
			5: 
				playerPowerUps.mineCount = 2
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Adding another mine")
			6: 
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "None")
			7: 
				playerPowerUps.speed += 1
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Increases Player Speed")
			8: 
				playerPowerUps.mineCount *= 2
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Doubles Mines")
			9: 
				playerPowerUps.isReactiveAI = true
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "More reactive AI")
			10: 
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Remove 30 seconds")
				playerPowerUps.timer -= 30
			11:
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Mines Spawn frequently")
				playerPowerUps.spawnMinesFast = true
	else:
		var randomNumber = rng.randi_range(0, 4)
		match randomNumber:
			0: 
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "None")
			1:
				playerPowerUps.health = 100
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Double Health")
			2:
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Player Doules Mines")
				playerPowerUps.mineCount *= 2
			3:
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Increases Player Speed")
				playerPowerUps.mineCount *= 2
			4:
				if playerPowerUpsList != null:
					playerPowerUpsList.set_item_text(3, playerPowerUpsList.get_item_text(3) + "Adds another mine")
				playerPowerUps.mineCount += 1
			

func level_won():
	if wave.number != 9 || isEndless:
		call_deferred("deleteWorld")
		shopInstance = shop.instantiate()
		add_child(shopInstance)
		var shop: Shop = get_node("/root/LevelPicker/Shop")
		shop.item_pressed.connect(item_selected)
		shop.setupShop(["Faster Zombies", "More Zombies", "Big Zombies"])
		wave.number += 1
		playerPowerUpsList = shop.find_child("PlayerPowerUps")
		playerPowerUpsList.set_item_text(0, playerPowerUpsList.get_item_text(0) + str(playerPowerUps.health))
		playerPowerUpsList.set_item_text(1, playerPowerUpsList.get_item_text(1) + str(playerPowerUps.speed))
		playerPowerUpsList.set_item_text(2, playerPowerUpsList.get_item_text(2) + str(playerPowerUps.timer))
		var zombiePowerUpsList: ItemList = shop.find_child("ZombiePowerUps")
		zombiePowerUpsList.set_item_text(0, zombiePowerUpsList.get_item_text(0) + str(zombiePowerUps.speed))
		zombiePowerUpsList.set_item_text(1, zombiePowerUpsList.get_item_text(1) + str(zombiePowerUps.zombieCount))
		zombiePowerUpsList.set_item_text(2, zombiePowerUpsList.get_item_text(2) + str(zombiePowerUps.damage))
		upgradePlayer()
	else:
		winScreenInstance = winScreen.instantiate()
		add_child(winScreenInstance)
		var endlessButton = get_node("/root/LevelPicker/WinScreen/Control/Button")
		endlessButton.pressed.connect(beginEndless)
	
func level_lost():
	call_deferred("deleteWorld")
	loseScreenInstance = loseScreen.instantiate()
	add_child(loseScreenInstance)
	var restartButton = get_node("/root/LevelPicker/LoseScreen/Control/Button")
	restartButton.pressed.connect(restartLevel)
	pass

func restartLevel():
	call_deferred("deleteLoseScreen")
	setupPowers()
	setupWorld()

func beginEndless():
	isEndless = true
	level_won()
	call_deferred("deleteWinScreen")
	
func item_selected(index: int):
	match index:
		0:
			zombiePowerUps.speed += 0.35
		1: 
			zombiePowerUps.zombieCount += 5
		2:
			zombiePowerUps.size += 0.1
			zombiePowerUps.damage += 10
	call_deferred("deleteShop")
	

func setupWorld():
	mainWorldInstance = mainWorld.instantiate()
	add_child(mainWorldInstance)
	var world: World = get_node("/root/LevelPicker/World")
	world.initWorld(wave)
	player = world.find_child("Player")
	player.playerPowerUps = playerPowerUps
	player.level_won.connect(level_won)
	player.health += playerPowerUps.health 
	player.speed = playerPowerUps.speed
	player.zombiePowerUps = zombiePowerUps
	player.setupHealth(player.health)
	loseTimer = world.find_child("LoseTimer", true)
	loseTimer.timeout.connect(level_lost)
	loseTimer.wait_time = playerPowerUps.timer
	loseTimer.start()
	
