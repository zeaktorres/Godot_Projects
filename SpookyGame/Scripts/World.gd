extends Node3D

signal start_timer

var zombie = load("res://Scenes/zombie.tscn")
var instance
@onready var navigation_region = $NavigationRegion3D
@export var timer: Clock
var ready_to_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_hit():
	pass # Replace with function body.


func _on_target_on_target_pressed(pos):
	if ready_to_spawn:
		instance = zombie.instantiate()
		instance.position = pos
		navigation_region.add_child(instance)
		ready_to_spawn = false
		emit_signal("start_timer")
		


func _on_clock_clock_timer_finished():
	ready_to_spawn = true
	pass # Replace with function body.
