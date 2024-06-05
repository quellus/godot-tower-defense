extends Node

@export var ammo_container: PackedScene

func get_ammo_container() -> AmmoContainer:
	var ac_instance = ammo_container.instantiate()
	add_child(ac_instance)
	return ac_instance
