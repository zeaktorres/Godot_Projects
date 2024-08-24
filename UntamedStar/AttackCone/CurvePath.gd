extends Node3D
class_name CurveNode
signal Finished
@export var endPath: Path3D
@export var startPath: Path3D
@onready var pathPointClass = load("res://AttackCone/PathPoint.gd")
@onready var isProcessing: Mutex = Mutex.new()
@onready var numberOfThreadsLeft = 0
var pathPointObjects: Array[PathPoint]
var tweens: Array[Tween] = []
	

func play():
	for tween: Tween in tweens:
		tween.play()

func init(timeInSeconds: float):
	var tween = create_tween()
	tween.pause()
	tween.tween_property(startPath, "position", endPath.position, timeInSeconds)
	tween.tween_callback(onFinish)
	tweens.append(tween)	
	numberOfThreadsLeft += 1 
	
	pathPointObjects = []
	for i in range(startPath.curve.get_baked_points().size()):
		pathPointObjects.append(pathPointClass.new())
		pathPointObjects[i].position = startPath.curve.get_point_position(i)
		var newTween = create_tween()
		var endPathPoint: Vector3 = endPath.curve.get_point_position(i)
		newTween.pause()
		newTween.tween_property(pathPointObjects[i], "position", endPathPoint, timeInSeconds)
		newTween.tween_callback(onFinish)
		tweens.append(newTween)
		numberOfThreadsLeft += 1 
	
func onFinish():
	isProcessing.lock()
	if numberOfThreadsLeft > 1:
		numberOfThreadsLeft -= 1
		isProcessing.unlock()
		return
			
	
	emit_signal("Finished")
	pass
	
	
func _physics_process(_delta: float) -> void:
	movePathForward()
	pass

func movePathForward():
	updatePathsPointsToTweenValue()
	
func updatePathsPointsToTweenValue():
	for i in range(pathPointObjects.size()):
		startPath.curve.set_point_position(i, pathPointObjects[i].position)
	
