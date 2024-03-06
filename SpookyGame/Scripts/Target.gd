extends Node3D



var rayOrigin = Vector3.ZERO
var rayEnd = Vector3.ZERO
@onready var camera = $"../../Camera3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var space_state = get_world_3d().direct_space_state

	var mouse_position = get_viewport().get_mouse_position()
	
	rayOrigin = camera.project_ray_origin(mouse_position)
	
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)

	var intersection = space_state.intersect_ray(query)
	
	if not intersection.is_empty() && Input.is_action_pressed("click"):
		var pos = intersection.position
		position = pos
