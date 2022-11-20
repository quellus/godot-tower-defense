extends Path

onready var gridmap: GridMap = get_node("/root/L_Main/GridMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	var coords: Array = gridmap.get_coords()
	curve.clear_points()
	for coord in coords:
		var point: Vector3 = gridmap.map_to_world(coord.x, 0, coord.y)
#		point.y = 1
		curve.add_point(point)
	pass # Replace with function body.
