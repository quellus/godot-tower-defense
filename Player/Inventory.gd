class_name Inventory extends Node3D

signal picked_up_rocket_bundle
signal dropped_rocket_bundle

enum PickupType {
	AMMO_BOX,
	BATTERY,
	ROCKET_BUNDLE,
	NONE,
}

func has_pickup() -> bool:
	return get_child_count() >= 1


func get_pickup_type() -> PickupType:
	if get_child_count() >= 1:
		var pickup = get_child(0)
		return pickup.type
	return PickupType.NONE


func get_pickup_ammo() -> int:
	if has_pickup():
		var pickup = get_child(0)
		return pickup.get_ammo()
	else:
		return 0


func get_pickup_item() -> Node3D:
	return get_child(0)


func pickup_item(target: Node3D) -> bool:
	if not has_pickup():
		print("inventory reparenting item")
		target.reparent(self)
		target.global_position = global_position
		target.rotation = Vector3(0,0,0)
		target.process_mode = Node.PROCESS_MODE_DISABLED
		if target.get_type() == PickupType.ROCKET_BUNDLE:
			picked_up_rocket_bundle.emit()
		return true
	return false


func drop_item():
	if has_pickup():
		var pickup = get_child(0)
		pickup.reparent(get_tree().root)
		pickup.process_mode = Node.PROCESS_MODE_ALWAYS
		pickup.global_rotation = global_rotation
		pickup.global_position = global_position
		pickup.apply_central_impulse(Vector3(0, 0, -2).rotated(Vector3(0, 1, 0), global_rotation.y))
		if pickup.get_type() == PickupType.ROCKET_BUNDLE:
			dropped_rocket_bundle.emit()


func item_taken(type: PickupType):
	if type == PickupType.ROCKET_BUNDLE:
		dropped_rocket_bundle.emit()


func remove_pickup():
	if has_pickup():
		var pickup = get_child(0)
		pickup.queue_free()
