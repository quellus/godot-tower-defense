extends CharacterBody3D

const ROTATION_SMOOTHING := 0.65
const SPEED := 10.0
const SLOWING_MULTIPLIER := 0.5
var speed_multiplier := 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	var spawn_pos = get_tree().root.get_node("L_Main/SpawnPoint").global_position
	spawn_pos.x = spawn_pos.x + randf_range(0.5, 2)
	global_position = spawn_pos


func _physics_process(delta):
	if is_multiplayer_authority():
		_move_character(delta)


func _move_character(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		rotation.y = lerp_angle(input_dir.angle_to(Vector2(0,-1)), rotation.y, 0.6)
		var intended_velocity = direction * SPEED * speed_multiplier
		
		velocity = velocity.lerp(intended_velocity, 0.2)
	else:
		velocity = velocity.lerp(Vector3.ZERO, 0.6)

	move_and_slide()


func _on_inventory_dropped_rocket_bundle():
	print("dropped rocket bundle")
	speed_multiplier = 1


func _on_inventory_picked_up_rocket_bundle():
	speed_multiplier = SLOWING_MULTIPLIER
