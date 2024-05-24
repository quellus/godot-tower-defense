extends CharacterBody3D

const ROTATION_SMOOTHING := 0.65
const SPEED := 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	_move_character(delta)


func _move_character(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if not input_dir == Vector2(0,0):
		velocity.x = (transform.basis * Vector3.FORWARD * SPEED).x
		velocity.z = (transform.basis * Vector3.FORWARD * SPEED).z
		rotation.y = lerp_angle(input_dir.angle_to(Vector2(0,-1)), rotation.y, 0.7)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
