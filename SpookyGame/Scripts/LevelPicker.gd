extends Node3D

var mainWorld = load("res://Scenes/World1.tscn")
var mainWorldInstance
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	setupWorld()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deleteWorld():
	remove_child(mainWorldInstance)
	mainWorldInstance.free()

func level_won():
	call_deferred("deleteWorld")
	#setupWorld()

func setupWorld():
	mainWorldInstance = mainWorld.instantiate()
	add_child(mainWorldInstance)
	player = get_node("/root/LevelPicker/World").find_child("Player")
	player.level_won.connect(level_won)
