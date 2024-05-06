extends Node3D

@onready var cam: Camera3D = get_node(NodePath("Camera3D"))
@onready var raycast: RayCast3D = get_node(NodePath("RayCast3D"))
@onready var towers: Node3D = get_node("/root/L_Main/Towers")
@onready var gridmap: GridMap = get_node("/root/L_Main/GridMap")

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

var pickup = Pickups.NONE

enum Pickups {
	AMMO_BOX,
	NONE
}

func _physics_process(delta) -> void:
	if raycast.is_colliding() and Input.is_action_just_pressed("fire"):
		var target = raycast.get_collider()
		var target_parent: Node = target.get_parent()
		if target.is_in_group("enemy") and target_parent.has_method("damage"): # enemy interaction
			target_parent.damage(1)
		elif target.is_in_group("tower") and target.has_method("add_ammo") and pickup == Pickups.AMMO_BOX: # tower interaction
			var ammo_box = get_node("../Pickups/AmmoBox")
			ammo_box.remove_ammo(ammo_box.get_ammo() - target.add_ammo(ammo_box.get_ammo()))
			if ammo_box.get_ammo() <= 0:
				pickup = Pickups.NONE
				ammo_box.visible = false
		elif pickup == Pickups.NONE and target.is_in_group("pickup"): # pickup interaction
			target.queue_free()
			var ammo_box = get_node("../Pickups/AmmoBox")
			ammo_box.visible = true
			pickup = Pickups.AMMO_BOX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()

func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x
