extends Node3D

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

@export var fast_close := true
@export var player_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if MultiplayerManager.singleplayer:
		_spawn_player(multiplayer.get_unique_id())
	
	if multiplayer.is_server():
		MultiplayerManager.new_player_joined.connect(_on_multiplayer_new_player_joined)
		for id in MultiplayerManager.players:
			print("spawning player")
			_spawn_player(id)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)

func _process(_delta) -> void:
	#print(Engine.get_frames_per_second())
	pass
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().quit() # Quits the game


func _on_multiplayer_new_player_joined(id: int):
	if multiplayer.is_server():
		_spawn_player(id)


func _spawn_player(id: int):
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	add_child(player_instance)
	var spawn_pos = $SpawnPoint.position
	spawn_pos.x = spawn_pos.x + randf_range(0.5, 2)
	player_instance.position = spawn_pos
