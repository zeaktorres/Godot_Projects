extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func areaEntered(body):
	print(body)
	
func areaExited(body):
	print(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
