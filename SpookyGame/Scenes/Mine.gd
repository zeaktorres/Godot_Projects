extends Node3D
class_name Mine

@onready var materialWhite = load("res://Mine_White.tres")
@onready var materialRed = load("res://Mine_Red.tres")

@onready var base: MeshInstance3D = $BaseLightingTurret1
@onready var top: MeshInstance3D = $MeshInstance3D

signal removeMe(node: Node3D)

var	isActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	base.set_surface_override_material(1, materialWhite)
	top.set_surface_override_material(0, materialWhite)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if isActive:
		body.get_parent().remove_child(body)
		body.free()
		emit_signal("removeMe", self)
	pass # Replace with function body.


func _on_start_timer_timeout():
	isActive = true
	base.set_surface_override_material(1, materialRed)
	top.set_surface_override_material(0, materialRed)
	pass # Replace with function body.
