extends Node3D

var mainWorld = load("res://Scenes/World1.tscn")
var shop = load("res://Scenes/Shop.tscn")
var loseScreen = load("res://Scenes/Lose_Screen.tscn")
var mainWorldInstance
var loseScreenInstance
var wave: Wave
var zombiePowerUps: ZombiePowerUps
var playerPowerUps: PlayerPowerUps
var shopInstance 
var player: Player
var loseTimer: Timer
@onready var playerPowerUpsLabel: ItemList = $Control/PlayerPowerUps

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

func upgradePlayer():
	print(wave.number)
	match wave.number:
		0:
			playerPowerUps.health += (100 * (wave.number + (1/4)))
		1:
			playerPowerUps.mineCount = 1
			print("HERE")

func level_won():
	call_deferred("deleteWorld")
	shopInstance = shop.instantiate()
	add_child(shopInstance)
	var shop: Shop = get_node("/root/LevelPicker/Shop")
	shop.item_pressed.connect(item_selected)
	shop.setupShop(["Faster Zombies", "More Zombies", "Big Zombies"])
	wave.number += 1
	var playerPowerUpsList: ItemList = shop.find_child("PlayerPowerUps")
	playerPowerUpsList.set_item_text(0, playerPowerUpsList.get_item_text(0) + str(playerPowerUps.health))
	playerPowerUpsList.set_item_text(1, playerPowerUpsList.get_item_text(1) + str(playerPowerUps.speed))
	playerPowerUpsList.set_item_text(2, playerPowerUpsList.get_item_text(2) + str(playerPowerUps.timer))
	var zombiePowerUpsList: ItemList = shop.find_child("ZombiePowerUps")
	zombiePowerUpsList.set_item_text(0, zombiePowerUpsList.get_item_text(0) + str(zombiePowerUps.speed))
	zombiePowerUpsList.set_item_text(1, zombiePowerUpsList.get_item_text(1) + str(zombiePowerUps.zombieCount))
	zombiePowerUpsList.set_item_text(2, zombiePowerUpsList.get_item_text(2) + str(zombiePowerUps.damage))
	upgradePlayer()
	
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
	
func item_selected(index: int):
	match index:
		0:
			zombiePowerUps.speed += 0.5
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
	
	# TODO REMOVE MINE COUNT HERE
	player.playerPowerUps = playerPowerUps
	player.playerPowerUps.mineCount = 1
	player.level_won.connect(level_won)
	player.health += playerPowerUps.health 
	player.speed = playerPowerUps.speed
	player.zombiePowerUps = zombiePowerUps
	player.setupHealth(player.health)
	loseTimer = world.find_child("LoseTimer", true)
	loseTimer.timeout.connect(level_lost)
	
