class_name Cell
var pos: Vector3
var isTaken: bool
var id: int

func isFree():
	return !isTaken
	
func getPosition():
	return pos
	
func _init(newPos: Vector3, newIsTaken: bool, newId: int):
	pos = newPos
	isTaken = newIsTaken
	id = newId
