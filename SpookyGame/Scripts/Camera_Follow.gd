extends Camera3D

@export var distance = 4.0
@export var height = 2.0 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var target = get_parent_node_3d().global_transform.origin
	var pos = global_transform.origin
	
	var offset = pos - target
	
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	look_at_from_position(pos, target, Vector3.UP)
	pass
