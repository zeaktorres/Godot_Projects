extends Node3D

@onready var timer = $Timer
var zombie = load("res://Scenes/Zombie.tscn")
@onready var ZombieHeadScreen: Label = $ZombieHead/ZombieHead/ZombieHeadSprite/Label
@export var zombiesLeft = 10
var instance
@onready var navigation_region = $NavigationRegion3D/Zombies
@export var clock: Clock
var ready_to_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	ZombieHeadScreen.text = str(zombiesLeft)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_hit():
	pass # Replace with function body.


func _on_target_on_target_pressed(pos):
	if zombiesLeft > 0 && ready_to_spawn:
		instance = zombie.instantiate()
		instance.position = pos
		navigation_region.add_child(instance)
		zombiesLeft -= 1
		ZombieHeadScreen.text = str(zombiesLeft)
		ready_to_spawn = false
		timer.start()
		
		





func _on_timer_timeout():
	ready_to_spawn = true
	pass # Replace with function body.
