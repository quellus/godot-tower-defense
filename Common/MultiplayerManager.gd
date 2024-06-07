extends Node

signal new_player_joined(id: int)

var players := []
var peer: MultiplayerPeer
var singleplayer = true

@rpc("any_peer")
func player_joined(id: int):
	if not MultiplayerManager.players.has(id):
		new_player_joined.emit(id)
		MultiplayerManager.players.append(id)
	if multiplayer.is_server():
		print("Telling clients about players")
		for i in MultiplayerManager.players:
			print("Telling clients about player" + str(i))
			player_joined.rpc(i)
