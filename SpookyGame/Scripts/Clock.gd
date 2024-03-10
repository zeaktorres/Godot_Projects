extends Node2D
class_name Clock

signal clock_timer_finished

@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	emit_signal("clock_timer_finished")
	pass # Replace with function body.

func _on_world_start_timer():
	timer.start()
	pass # Replace with function body.
