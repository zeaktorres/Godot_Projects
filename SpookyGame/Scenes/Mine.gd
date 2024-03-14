extends Node3D
class_name Mine

@onready var materialWhite = load("res://Mine_White.tres")
@onready var materialRed = load("res://Mine_Red.tres")

@onready var base: MeshInstance3D = $BaseLightingTurret1
@onready var top: MeshInstance3D = $MeshInstance3D
@onready var blowUpSound: AudioStreamPlayer = $AudioStreamPlayer
@onready var deleteTimer: Timer = $DeleteTimer
@onready var collectTimer: Timer = $CollectTimer

signal removeMe(node: Node3D)
var bodies = []

var	isActive = false
var isBlowingUp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	base.set_surface_override_material(1, materialWhite)
	top.set_surface_override_material(0, materialWhite)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(newBody):
	var isBodyInBodies = false
	for body in bodies:
		if body == newBody:
			isBodyInBodies = true
			break
	if isBodyInBodies == false:
		bodies.append(newBody)
	if isActive && collectTimer.is_stopped() && isBlowingUp == false:
		collectTimer.start()
		isBlowingUp = true
	pass # Replace with function body.


func _on_start_timer_timeout():
	if bodies.size() > 0:
		collectTimer.start()
		isBlowingUp = true
	isActive = true
	base.set_surface_override_material(1, materialRed)
	top.set_surface_override_material(0, materialRed)
	pass # Replace with function body.


func _on_delete_timer_timeout():
	emit_signal("removeMe", self)
	pass # Replace with function body.


func _on_collect_timer_timeout():
	for body in bodies:
		if is_instance_valid(body):
			body.get_parent().remove_child(body)
			body.free()
	blowUpSound.play()
	deleteTimer.start()
	base.hide()
	top.hide()
	pass # Replace with function body.


func _on_area_3d_body_exited(newBody):
	for i in range(bodies.size()):
		if bodies[i] == newBody:
			bodies.remove_at(i)
			break
	pass # Replace with function body.
