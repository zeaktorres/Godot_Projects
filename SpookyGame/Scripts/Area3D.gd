extends Area3D

var mesh: MeshInstance3D
var id = -1
@onready var greenMaterial = load("res://green_box.tres")
@onready var whiteMaterial = load("res://white_box.tres") 
var cell: Cell

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", body_entered)
	connect("body_exited", body_exited)
	#mesh = get_child(0)
	pass # Replace with function body.
	
func body_entered(body):
	#mesh.set_surface_override_material(0, greenMaterial)
	cell.isTaken = true
	pass	

func body_exited(body):
	#mesh.set_surface_override_material(0, whiteMaterial)
	cell.isTaken = false
	pass
	
func setCell(newCell):
	cell = newCell
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
