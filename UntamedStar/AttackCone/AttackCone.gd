extends Node3D
class_name AttackCone

@export var curve: CurveNode
signal Finished
signal Ready

func _ready() -> void:
	emit_signal("Ready")

func play(timeInSeconds: float):
	curve.init(timeInSeconds)
	curve.play()

func onFinish():
	emit_signal("Finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
