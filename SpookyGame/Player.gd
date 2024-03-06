extends CharacterBody3D

# How fast the player moves in meters per second.
@export var SPEED = 4
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

@onready var target = $"../NavigationRegion3D/Target"
@onready var nav_agent = $Pivot/Character/NavigationAgent3D
var nav_loaded: bool = false


func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	velocity = Vector3.ZERO
	nav_agent.target_position = target.position
	var next_nav_point = nav_agent.get_next_path_position()
	var move_to_direction = next_nav_point - global_transform.origin
	var look_at_direction = Vector3(move_to_direction.x, 0, move_to_direction.z)
	direction = direction.lerp(look_at_direction.normalized(), delta * 10)
	direction = direction.normalized()
	$Pivot.basis = Basis.looking_at(direction)
	print()
	
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	if (global_transform.origin.distance_to(target.position) < 2):
		velocity = Vector3.ZERO
		
	if (velocity.length() > 0):
		$Pivot/Character/AnimationPlayer.play("Walk")
	else:
		$Pivot/Character/AnimationPlayer.play("Iddle")
	

	# Moving the Character
	move_and_slide()
