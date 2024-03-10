extends GridMap

@onready var Zombies = $"../Zombies" 

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_used_cells())

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Zombies.get_child_count() > 0):
		print(isInsideCell(get_used_cells()[0], Zombies.get_children()[0]))
	pass
	
func isInsideCell(cell, zombie):
	print(cell.x, zombie.position.x)
	print()
	
	if (cell.x - 0.5 > zombie.position.x && cell.x + 0.5 > zombie.position.x):
		return true
	return false	
