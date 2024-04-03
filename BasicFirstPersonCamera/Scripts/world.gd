extends Node3D
class_name World

@onready var main_menu: Control = $MainMenu/MainMenu
@onready var pause_menu: Control = $Pause/PauseMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
var boolIsFocused = true

const Player = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("exit"):
		if pause_menu.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			pause_menu.hide()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_menu.show()
			


func _on_host_button_pressed():
	print(get_tree().root)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	print(get_tree().root)
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	pass # Replace with function body.
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.set_multiplayer_authority(peer_id)
	player.multiplayer_id = peer_id
	player.name = str(peer_id)
	add_child(player)
