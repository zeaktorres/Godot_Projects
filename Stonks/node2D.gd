extends VBoxContainer
class_name World


# Called when the node enters the scene tree for the first time.
func _ready():
	var graphContainer := $GraphContainer
	var graphNode = load("res://Scenes/Control.tscn")
	var graphNodeInstance: LineChart  = graphNode.instantiate()
	graphContainer.add_child(graphNodeInstance)
	graphNodeInstance.initialize([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [100, 150, 90, 100, 110, 150, 160, 180, 200, 220, 230])
	graphNodeInstance.size_flags_vertical = 3

