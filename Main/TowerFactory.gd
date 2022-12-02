extends Spatial

onready var tower = load("res://Tower.tscn")

var towerLocs: Array = []

func add_tower(location: Vector3):
	var towerInstance = tower.instance()
	add_child(towerInstance)
	towerInstance.global_translation = location
	towerLocs.append(location)

func is_tower_at(location: Vector3):
	for loc in towerLocs:
		if (loc == location):
			return true
	return false
