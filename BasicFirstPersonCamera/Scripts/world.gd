extends Node3D
class_name World

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
var boolIsFocused = true
var mainMenuHidden = false

const Player = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	mainMenuHidden = true
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	pass # Replace with function body.
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.multiplayer_id = peer_id
	add_child(player)
