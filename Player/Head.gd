extends Spatial

onready var cam: Camera = get_node(NodePath("Camera"))
onready var raycast: RayCast = get_node(NodePath("RayCast"))
onready var root = get_node("/root/L_Main")
onready var tower = load("res://Tower.tscn")
onready var indicator = get_node("Indicator")

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

func _physics_process(delta) -> void:
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.name == "GridMap":
			var location = raycast.get_collision_point()
			var coord = target.world_to_map(location)
			indicator.global_translation = target.map_to_world(coord.x, coord.y, coord.z)
			if Input.is_action_just_pressed("fire"):
				var towerInstance = tower.instance()
				root.add_child(towerInstance)
				towerInstance.global_translation = indicator.global_translation
			indicator.visible = true
		else:
			indicator.visible = false
		# TODO spawn tower at target location
		if Input.is_action_just_pressed("fire"):
			if target.has_method("damage"):
				target.damage(1)
	else:
		indicator.visible = false

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
