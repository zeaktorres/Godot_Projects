extends CanvasLayer

signal hostButtonPressed
signal joinButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	emit_signal("hostButtonPressed")
	pass # Replace with function body.


func _on_join_button_pressed():
	emit_signal("joinButtonPressed")
	pass # Replace with function body.
