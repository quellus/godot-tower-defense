extends Node3D

@onready var tower = load("res://Tower/Tower.tscn")

var towerLocs: Array = []

func add_tower(location: Vector3):
	var towerInstance = tower.instantiate()
	add_child(towerInstance)
	towerInstance.global_position = location
	towerLocs.append(location)

func is_tower_at(location: Vector3):
	for loc in towerLocs:
		if (loc == location):
			return true
	return false
