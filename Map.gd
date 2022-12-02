extends GridMap

var coords: Array = [
	Vector2(5,0),
	Vector2(5,10),
	Vector2(15,10),
	Vector2(15,5),
	Vector2(10,5),
	Vector2(10,19)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	for x in range(20):
		for y in range(20):
			set_cell_item(x, 0, y, 0)
	var lastCoord = null
	for coord in coords:
		set_cell_item(coord.x, 0, coord.y, 1)
		if lastCoord != null:
			if lastCoord.x == coord.x:
				var lower = min(lastCoord.y, coord.y)
				var higher = max(lastCoord.y, coord.y)
				for y in range(lower, higher):
					set_cell_item(coord.x, 0, y, 1)
			elif lastCoord.y == coord.y:
				var lower = min(lastCoord.x, coord.x)
				var higher = max(lastCoord.x, coord.x)
				for x in range(lower, higher):
					set_cell_item(x, 0, coord.y, 1)
		lastCoord = coord

func can_place_tower(location: Vector3)-> bool:
	var coord = world_to_map(location)
	return get_cell_item(coord.x, coord.y, coord.z) == 0

func get_coords():
	return coords
