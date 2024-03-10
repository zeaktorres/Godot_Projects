extends CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func body_entered_test(body:Node):
	print("woot")
	print(body)
	pass
