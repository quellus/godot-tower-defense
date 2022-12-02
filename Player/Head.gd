extends Spatial

onready var cam: Camera = get_node(NodePath("Camera"))
onready var raycast: RayCast = get_node(NodePath("RayCast"))
onready var towers: Spatial = get_node("/root/L_Main/Towers")
onready var indicator: Spatial = get_node("Indicator")
onready var gridmap: GridMap = get_node("/root/L_Main/GridMap")

onready var tower = load("res://Tower.tscn")

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

func _physics_process(delta) -> void:
	if raycast.is_colliding():
		var target = raycast.get_collider()
		indicator.visible = false
		var location = raycast.get_collision_point()
		if target.name == "GridMap":
			var map_pos = target.world_to_map(location)
			var world_pos = target.map_to_world(map_pos.x, map_pos.y, map_pos.z)
			if gridmap.can_place_tower(location) && !towers.is_tower_at(world_pos):
				indicator.global_translation = world_pos
				indicator.visible = true
				if Input.is_action_just_pressed("fire"):
					towers.add_tower(indicator.global_translation)
		if Input.is_action_just_pressed("fire"):
			if target.has_method("damage"):
				target.damage(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)

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
