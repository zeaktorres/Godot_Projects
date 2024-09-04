extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed: int = 7
# The downward acceleration when in the air, in meters per second squared.
@onready var animationPlayer: AnimationPlayer = $Pivot/Robot/AnimationPlayer

var attackCone: Resource = load("res://AttackCone/AttackCone.tscn")
var attackConeInstance: AttackCone

@export var pivot: Pivot
@export var target: Target
@export var frontTarget: FrontTarget

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

func _physics_process(delta):
	if Input.is_action_pressed("attack") && animationPlayer.current_animation != "Punch":
		playAttackAnimation()
		addAttackCone()
	
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
		if animationPlayer.current_animation != "Punch":
			animationPlayer.speed_scale = 1
			animationPlayer.play("Walk")
	else:
		if animationPlayer.current_animation != "Punch":
			animationPlayer.speed_scale = 1
			animationPlayer.play("Idle")
		
	
	# Moving the Character
	move_and_slide()
	
func playAttackAnimation():
	animationPlayer.clear_queue()
	animationPlayer.speed_scale = 0.83333 / 2.5
	animationPlayer.play("Punch")

func addAttackCone():
	if attackConeInstance != null:
		pivot.remove_child(attackConeInstance)
		print(attackConeInstance)
		attackConeInstance.queue_free()
	
	attackConeInstance = attackCone.instantiate()
	attackConeInstance.transform = attackConeInstance.transform.scaled(Vector3(2,2,2))
	attackConeInstance.position.z -= 1
	attackConeInstance.Finished.connect(cleanAttackCone)
	attackConeInstance.Ready.connect(playAttackCone)
	pivot.add_child(attackConeInstance)
	pass
	
func playAttackCone():
	attackConeInstance.play(1.0)
	

func cleanAttackCone():
	if attackConeInstance:
		pivot.remove_child(attackConeInstance)
		attackConeInstance.queue_free()
	
	
