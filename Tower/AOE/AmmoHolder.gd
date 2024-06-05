class_name AmmoHolder extends Node3D

func get_ammo() -> int:
	if get_child_count() >= 1:
		var ammo_container = get_child(0)
		return ammo_container.get_ammo()
	else:
		return 0


func get_max_ammo() -> int:
	if get_child_count() >= 1:
		var ammo_container = get_child(0)
		return ammo_container.get_ammo()
	else:
		return 0


func remove_ammo(amount: int) -> bool:
	if get_child_count() >= 1:
		var ammo_container = get_child(0)
		ammo_container.remove_ammo(amount)
		return true
	else:
		return false


func has_ammo_container() -> bool:
	return get_child_count() >= 1


func get_ammo_container() -> AmmoContainer:
	if has_ammo_container():
		return get_child(0)
	return null
	

func add_ammo_container(target: AmmoContainer) -> void:
	if has_ammo_container():
		remove_ammo_container()
	target.reparent(self)
	target.position = position
	target.rotation = Vector3(0,0,0)
	target.process_mode = Node.PROCESS_MODE_DISABLED


func remove_ammo_container():
	var ammo_container = get_ammo_container()
	if not ammo_container == null:
		ammo_container.queue_free()
