extends Spatial

onready var cam: Camera = get_node(NodePath("Camera"))
onready var raycast: RayCast = get_node(NodePath("RayCast"))
onready var towers: Spatial = get_node("/root/L_Main/Towers")
onready var gridmap: GridMap = get_node("/root/L_Main/GridMap")

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

func _physics_process(delta) -> void:
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if Input.is_action_just_pressed("fire"):
			var enemy: Node = target.get_parent()
			if enemy.has_method("damage"):
				enemy.damage(1)
			elif target.has_method("refill_health"): 
				target.refill_health()

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
