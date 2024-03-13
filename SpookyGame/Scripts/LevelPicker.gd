extends Node3D

var mainWorld = load("res://Scenes/World1.tscn")
var shop = load("res://Scenes/Shop.tscn")
var mainWorldInstance
var wave: Wave
var zombiePowerUps: ZombiePowerUps
var shopInstance 
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = Wave.new()
	zombiePowerUps = ZombiePowerUps.new()
	wave.zombiePowerUps = zombiePowerUps
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

func level_won():
	call_deferred("deleteWorld")
	shopInstance = shop.instantiate()
	add_child(shopInstance)
	var shop: Shop = get_node("/root/LevelPicker/Shop")
	shop.item_pressed.connect(item_selected)
	shop.setupShop(["Faster Zombies", "More Zombies", "Big Zombies"])
	wave.number += 1
	#setupWorld()
	
func item_selected(index: int):
	match index:
		0:
			zombiePowerUps.speed += 2
		1: 
			zombiePowerUps.zombieCount += 5
		2:
			zombiePowerUps.size += 0.1
			zombiePowerUps.damage *= 2
	call_deferred("deleteShop")
	

func setupWorld():
	mainWorldInstance = mainWorld.instantiate()
	add_child(mainWorldInstance)
	var world: World = get_node("/root/LevelPicker/World")
	world.initWorld(wave)
	player = world.find_child("Player")
	player.level_won.connect(level_won)
	player.health *= (wave.number + 1)
	player.setupHealth(player.health)
