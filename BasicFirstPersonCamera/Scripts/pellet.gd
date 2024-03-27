extends GPUParticles3D
class_name Pellet

var direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("finished", onFinished)
	get_process_material().velocity_pivot = direction
	get_process_material().direction = Vector3(direction.x * -1, direction.y, direction.z * -1)
	pass # RepPersonMovement/'lace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	#move_toward(position.x + (direction.x * 1), position.y + (direction.y * 1), position.z + (direction.z * 1) )
	pass

func onFinished():
	get_parent().remove_child(self)
	queue_free()
