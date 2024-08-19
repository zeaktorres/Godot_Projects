extends Node3D
@export var endPath: Path3D
@export var startPath: Path3D
@export var startPathPolygon: CSGPolygon3D
@export var endPathPolygon: CSGPolygon3D
var pathPointObjects: Array[PathPoint]
	

var t1 = 0.0


@export var maxTime: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var tween = create_tween()
	tween.tween_property(startPath, "position", endPath.position, 1.5)
	tween.play()
	
	var pathTweens = []
	pathPointObjects = []
	var pathPointClass = load("res://path_point.gd")
	for i in range(startPath.curve.get_baked_points().size()):
		pathPointObjects.append(pathPointClass.new())
		pathPointObjects[i].position = startPath.curve.get_point_position(i)
		var newTween = create_tween()
		var point: Vector3 = startPath.curve.get_point_position(i)
		var endPathPoint: Vector3 = endPath.curve.get_point_position(i)
		newTween.tween_property(pathPointObjects[i], "position", endPathPoint, 1.5)
		pathTweens.append(newTween)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	movePathForward(delta)
	pass
	

func movePathForward(delta: float):
	t1 += delta * 0.04
	
	## update start paths points
	#updatePathsPoints(t1)
	updatePathsPointsToTweenValue()
	
	## update start paths position
	#startPath.transform = startPath.transform.interpolate_with(endPath.transform, t1)
	print(t1)
	
func updatePathsPointsToTweenValue():
	for i in range(pathPointObjects.size()):
		print(pathPointObjects[i].position)
		startPath.curve.set_point_position(i, pathPointObjects[i].position)

func updatePathsPoints(t1: float):
	for i in range(startPath.curve.get_baked_points().size()):
		var point: Vector3 = startPath.curve.get_point_position(i)
		var endPathPoint: Vector3 = endPath.curve.get_point_position(i)
		startPath.curve.set_point_position(i, point.lerp(endPathPoint, t1))
	
