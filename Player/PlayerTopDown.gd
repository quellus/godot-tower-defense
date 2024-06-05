extends CharacterBody3D

const ROTATION_SMOOTHING := 0.65
const SPEED := 10.0
const SLOWING_MULTIPLIER := 0.5
var speed_multiplier := 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	_move_character(delta)


func _move_character(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		rotation.y = lerp_angle(input_dir.angle_to(Vector2(0,-1)), rotation.y, 0.7)
		velocity.x = direction.x * SPEED * speed_multiplier
		velocity.z = direction.z * SPEED * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speed_multiplier)
		velocity.z = move_toward(velocity.z, 0, SPEED * speed_multiplier)

	move_and_slide()


func _on_inventory_dropped_rocket_bundle():
	print("dropped rocket bundle")
	speed_multiplier = 1


func _on_inventory_picked_up_rocket_bundle():
	speed_multiplier = SLOWING_MULTIPLIER
