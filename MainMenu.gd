extends Control

@onready var main_scene = preload("res://Main/L_Main.tscn")
var address = "127.0.0.1"
var port = 5487
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)


func _on_start_pressed():
	var main_main_menu = $MainMainMenu
	var multiplayer_menu = $MultiplayerMenu
	main_main_menu.visible = false
	multiplayer_menu.visible = true


func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit() # Quits the game


func _on_singleplayer_pressed():
	MultiplayerManager.singleplayer = true
	get_tree().change_scene_to_packed(main_scene)


func _on_client_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)
	MultiplayerManager.peer = peer
	MultiplayerManager.singleplayer = false


func _on_server_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host")
		return
	multiplayer.set_multiplayer_peer(peer)
	MultiplayerManager.peer = peer
	MultiplayerManager.player_joined(multiplayer.get_unique_id())
	MultiplayerManager.singleplayer = false


func _on_peer_connected(_id):
	print("peer connected")
	get_tree().change_scene_to_packed(main_scene)


func _on_peer_disconnected(_id):
	print("peer disconnected")
	
	
func _on_connected_to_server():
	print("Connected to server")
	MultiplayerManager.player_joined.rpc_id(1, multiplayer.get_unique_id())
	
	
func _on_connection_failed():
	print("Connection failed")
