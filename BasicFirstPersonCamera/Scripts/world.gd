extends Node3D
class_name World

var main_menu: Control
var pause_menu: Control
var address_entry
const PORT = 2565
var enet_peer = ENetMultiplayerPeer.new()
var boolIsFocused = true

const PlayerScene = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("Server"):
		hostServer()
		return
	main_menu = $MainMenu/MainMenu
	address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
	pause_menu = $Pause/PauseMenu
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
			


func hostServer():
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	upnp_setup()
	

func _on_host_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_menu.hide()
	
	hostServer()
	#add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	print(get_tree().root)
	main_menu.hide()
	
	print(address_entry)
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	pass # Replace with function body.

## Initialize the spawner
func _enter_tree() -> void:
	var spawner := $MultiplayerSpawner
	spawner.spawn_function = _spawn_player

func _spawn_player(id: int):
	var player := PlayerScene.instantiate()

	# Rather than changing the authority of the player itself,
	# change the body and its children (recursively)
	# to allow the player's position to be synchronized
	# but not the visibility
	player.set_multiplayer_authority(id)

	player.multiplayer_id = id # I like to also store this on players
	player.name = str(id)
	return player
	
func add_player(id: int):
	# The id here will get sent to other peers on spawn automatically
	$MultiplayerSpawner.spawn(id)

func remove_player(id: int):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()


func _on_pause_exit_button():
	get_tree().quit()
	pass # Replace with function body.
	


func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	#print("Success! Join Address: %s" % upnp.query_external_address())
