extends GridMap
class_name GridPath



@onready var Zombies = $"../Zombies" 
@onready var grid = $"../Grid"
@onready var greenMaterial = load("res://green_box.tres")
@onready var whiteMaterial = load("res://white_box.tres") 
@onready var area3DScript = load("res://Scripts/Area3D.gd")
var cells = []


		

# Called when the node enters the scene tree for the first time.
func createNewBox(pos, id) -> Cell:
	var area_instance = Area3D.new()
	var collision_shape_3D = CollisionShape3D.new()
	var shape3D = BoxShape3D.new()
	collision_shape_3D.set_shape(shape3D)
	grid.add_child(area_instance)
	var box_mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh_instance.mesh = box_mesh
	area_instance.position = Vector3(pos[0] + 0.5, pos[1] + 1.5, pos[2] + 0.5)
	area_instance.add_child(box_mesh_instance)
	area_instance.set_script(area3DScript)
	area_instance.set_collision_layer(2)
	area_instance.set_collision_mask(2)
	area_instance.add_child(collision_shape_3D)
	var cell = Cell.new(pos, false, id)
	area_instance.setCell(cell)
	return cell
	

func _ready():
	var meshList = get_meshes()
	var id = 0
	var row = []
	for i in get_used_cells():
		row.append(createNewBox(i, id))
		id += 1
		if id % 4 == 0:
			cells.append(row)
			row = []
	pass # Replace with function body.
	
func getFreeCells():
	var freeCells = []
	for row in cells:
		for cell in row:
			if cell.isFree():
				freeCells.append(cell)
	return freeCells
