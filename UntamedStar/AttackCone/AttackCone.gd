extends Node3D

@export var curve: CurveNode

func _ready() -> void:
	play(1.5)

func play(timeInSeconds: float):
	curve.init(timeInSeconds)
	curve.play()

func onFinish():
	emit_signal("Finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
