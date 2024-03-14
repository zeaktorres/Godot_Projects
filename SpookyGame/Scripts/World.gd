extends Node3D
class_name World
@onready var timer = $ZombieSpawn
var zombie = load("res://Scenes/Zombie.tscn")
@onready var ZombieHeadScreen: Label = $ZombieHead/Control/Control/Label
@export var zombiesLeft = 20
var instance: Zombie
@onready var navigation_region = $NavigationRegion3D/Zombies
@export var clock: Clock
@onready var loseTimer: Timer = $TimerContainer/LoseTimer
@onready var timeLeftLabel: Label = $TimerContainer/TimeLeft
var ready_to_spawn = true
var wave: Wave
@onready var player: Player = $NavigationRegion3D/Player


func initWorld(newWave):
	wave = newWave
	zombiesLeft = wave.zombiePowerUps.zombieCount
	$WaveContainer/Health/Wave_Count.text = "WAVE " + str(wave.number + 1)
	ZombieHeadScreen.text = str(zombiesLeft)
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timeLeftLabel.text = "Time: " + str(int(loseTimer.time_left))
	pass


func _on_player_player_hit():
	pass # Replace with function body.


func _on_target_on_target_pressed(pos):
	if zombiesLeft > 0 && ready_to_spawn:
		var changeTargetsPlayerTimer: Timer = player.find_child("ChangeTargets")
		changeTargetsPlayerTimer.start()
		player.can_change_targets = false
		instance = zombie.instantiate()
		instance.scale = instance.scale * wave.zombiePowerUps.size
		instance.speed = wave.zombiePowerUps.speed
		instance.position = Vector3(pos.x , pos.y * (wave.zombiePowerUps.size), pos.z)
		navigation_region.add_child(instance)
		zombiesLeft -= 1
		ZombieHeadScreen.text = str(zombiesLeft)
		ready_to_spawn = false
		timer.start()

func _on_timer_timeout():
	ready_to_spawn = true
	pass # Replace with function body.
