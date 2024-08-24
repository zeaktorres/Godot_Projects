extends Camera3D

@export var distance = 8.0
@export var height = 4.0 
@export var cameraTarget: Target
@export var frontTargetPivot: FrontTargetPivot
@export var turnSpeed: float
@onready var animationPlayer: AnimationPlayer = get_node("/root/World/Robot/Pivot/Robot/AnimationPlayer")

# Called when the node enters the scene tree for the first time.ww
func _ready():
	set_physics_process(true)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "down") * -1
	if Input.is_action_pressed("right_mouse"):
		frontTargetPivot.rotate_y(deg_to_rad(Input.get_last_mouse_velocity()[0] / 800) * -1)
	if input_dir.x * input_dir.x > 0:
		frontTargetPivot.rotate_y(deg_to_rad(input_dir.x * turnSpeed))
		animationPlayer.play("Walk")
		
	
	var target = get_parent_node_3d().global_transform.origin
	var pos = global_transform.origin
	
	var offset = pos - target
	
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	look_at_from_position(pos, target, Vector3.UP)
	pass
