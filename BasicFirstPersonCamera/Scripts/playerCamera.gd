extends Camera3D

@onready var rayCast: RayCast3D = $RayCast3D
@onready var rootNode: Node3D = get_node("/root/World")
@onready var hitMesh: MeshInstance3D
@onready var sphereMesh: SphereMesh = SphereMesh.new()
@onready var redMaterial: Material = load("res://Materials/red_material.tres")
@export var player: Player

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
	if not is_multiplayer_authority(): return
	
	if hasHitMesh: 
		rootNode.remove_child(hitMesh)	
	rootNode.add_child(hitMesh)
	
	if rayCast.is_colliding():
		hitMesh.position = rayCast.get_collision_point()
		hasHitMesh = true
		
		var hit_player: Player = rayCast.get_collider()
		hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
