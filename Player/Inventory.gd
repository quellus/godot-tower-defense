extends Node3D

@onready var ammo_box: Node3D = get_node("AmmoBox")
@onready var battery: Node3D = get_node("Battery")
@onready var rocket_bundle: Node3D = get_node("RocketBundle")

signal picked_up_rocket_bundle
signal dropped_rocket_bundle

var pickup = Pickup.NONE

enum Pickup {
	AMMO_BOX,
	BATTERY,
	ROCKET_BUNDLE,
	NONE
}


func pickup_battery(amount: int) -> void:
	_pickup_item(battery, amount, Pickup.BATTERY)


func pickup_ammo(amount: int) -> void:
	_pickup_item(ammo_box, amount, Pickup.AMMO_BOX)


func pickup_rocket_bundle(amount: int) -> void:
	picked_up_rocket_bundle.emit()
	_pickup_item(rocket_bundle, amount, Pickup.ROCKET_BUNDLE)


func remove_battery() -> int:
	return _remove_pickup(battery)


func remove_ammo() -> int:
	return _remove_pickup(ammo_box)


func remove_rocket_bundle() -> int:
	dropped_rocket_bundle.emit()
	return _remove_pickup(rocket_bundle)


func _pickup_item(instance, amount: int, type: Pickup) -> void:
	instance.set_ammo(amount)
	instance.visible = true
	pickup = type


func _remove_pickup(instance) -> int:
	instance.visible = false
	pickup = Pickup.NONE
	return instance.get_ammo()
