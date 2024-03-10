extends Node2D


@onready var timer = $"../Timer"
@onready var line = $Line2D
@onready var lineContainer = $LineContainer
var previousInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2(0, -200), 200, Color.WHITE)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame
# TODO, fix this buggy mess
func _physics_process(delta):
	if floor(rad_to_deg(line.rotation)) > -3:
		for n in lineContainer.get_children():
			lineContainer.remove_child(n)
			n.queue_free()
	else:
		var new_line = line.duplicate()
		new_line.rotation = deg_to_rad((rad_to_deg(new_line.rotation)))
		lineContainer.add_child(new_line)
	if !timer.is_stopped():
		line.rotation = deg_to_rad((360 * (timer.time_left / timer.wait_time)  * -1))
	
