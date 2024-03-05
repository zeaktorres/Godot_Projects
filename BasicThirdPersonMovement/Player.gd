extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 7
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "down")
	var look_at_direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	direction = direction.lerp(look_at_direction.normalized(), delta * 2)
	
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		
	
	if look_at_direction.x == 0 && look_at_direction.z == 0:
		velocity = Vector3.ZERO
		
	if (velocity.length() > 0):
		$Pivot/Character/AnimationPlayer.play("Walk")
	else:
		$Pivot/Character/AnimationPlayer.play("Iddle")
	

	# Moving the Character
	move_and_slide()
