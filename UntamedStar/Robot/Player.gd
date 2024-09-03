extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed: int = 7
# The downward acceleration when in the air, in meters per second squared.

@onready var animationPlayer: AnimationPlayer = $Pivot/Robot/AnimationPlayer
@export var pivot: Pivot
@export var target: Target
@export var frontTarget: FrontTarget

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "down") * -1
	direction = global_position.direction_to(frontTarget.global_position) 
	direction = direction.normalized()
	pivot.look_at(frontTarget.global_position, Vector3.UP)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed * input_dir.y
			velocity.z = direction.z * speed * input_dir.y
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
			
	if input_dir.y == 0:
		velocity = Vector3.ZERO
		
	if (velocity.length() > 0):
		animationPlayer.play("Walk")
	else:
		animationPlayer.play("Idle")
		
	
	# Moving the Character
	move_and_slide()
