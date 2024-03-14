extends HBoxContainer
class_name Shop

signal item_pressed

@onready var itemList: ItemList = $Control/ItemList

var unlockShop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setupShop(items):
	for item in items:
		itemList.add_item(item)

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if unlockShop:
		emit_signal("item_pressed", index)
	pass # Replace with function body.


func _on_timer_timeout():
	unlockShop = true
	pass # Replace with function body.
