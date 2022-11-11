extends KinematicBody

onready var map = get_node("/root/L_Main/GridMap")

var coords: Array = []
var currentTarget: Vector2 = Vector2()
var currentTargetIndex: int = 0
var vel : Vector3 = Vector3()
var targetDistEpsilon = 0.2
var moveSpeed = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	coords = map.get_coords()
	var first_point = coords[0]
	global_translate(map.map_to_world(first_point.x, 0, first_point.y))
	
	# TODO Delete this
	currentTarget = coords[1]

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	vel.y = 0
	var currentTargetTranslation = map.map_to_world(currentTarget.x, 0, currentTarget.y)
	currentTargetTranslation.y = translation.y
	# calculate the direction to the player
	var dir = (currentTargetTranslation - translation).normalized()
	dir.y = 0
	
	# move the enemy towards the player
	if translation.distance_to(currentTargetTranslation) > targetDistEpsilon:
		look_at(currentTargetTranslation, Vector3.UP)
		move_and_slide(dir * moveSpeed, Vector3.UP)
	else:
		currentTargetIndex += 1
		if currentTargetIndex < coords.size():
			currentTarget = coords[currentTargetIndex]
		else:
			queue_free()
	vel = move_and_slide(vel, Vector3.UP)

	
	pass
