extends GridMap

@onready var Zombies = $"../Zombies" 

# Called when the node enters the scene tree for the first time.
func _ready():
	print(map_to_local(get_used_cells()[0]))

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
func isInsideCell(cell, zombie):
	
	if (cell.x - 0.5 > zombie.position.x && cell.x + 0.5 > zombie.position.x):
		return true
	return false	
