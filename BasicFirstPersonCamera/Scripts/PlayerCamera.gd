extends Camera3D

@onready var rayCast: RayCast3D = $RayCast3D
@onready var rootNode: Node3D = get_node("/root/Node3D")
@onready var hitMesh: MeshInstance3D
@onready var sphereMesh: SphereMesh = SphereMesh.new()
@onready var redMaterial: Material = load("res://Materials/red_material.tres")


var hasHitMesh = false
# Called when the node enters the scene tree for the first time.
func _ready():
	sphereMesh.height = 0.1
	sphereMesh.radius = 0.05
	sphereMesh.material = redMaterial
	hitMesh = MeshInstance3D.new()
	hitMesh.mesh = sphereMesh
	pass # Replace with function body. 
func _input(event):
	if event.is_action_pressed("shoot"):
		Get_Camera_Collision()

func Get_Camera_Collision():
	if hasHitMesh: 
		rootNode.remove_child(hitMesh)	
	rootNode.add_child(hitMesh)

	#if (hitMesh):
		#rootNode.remove_child(hitMesh)
		#hitMesh.free()
		
	
	
	
	if rayCast.is_colliding():
		hitMesh.position = rayCast.get_collision_point()
		hasHitMesh = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
