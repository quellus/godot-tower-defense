extends CharacterBody3D
class_name MovementController


@export var gravity_multiplier := 3.0
@export var acceleration := 8
@export var deceleration := 10
@export var air_control := 0.3 # (float, 0.0, 1.0, 0.05)
@export var jump_height := 10
@export var speed := 10
var speed_multiplier := 1.0
var direction := Vector3()
var input_axis := Vector2()
var snap := Vector3()
var stop_on_slope := true
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)


# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_platform_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	move_and_slide()


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction -= aim.z
	if input_axis.x <= -0.5:
		direction += aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed * speed_multiplier
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z


func _on_pickups_picked_up_rocket_bundle():
	print("picked up rocket bundle")
	speed_multiplier = 0.5


func _on_pickups_dropped_rocket_bundle():
	speed_multiplier = 1.0
