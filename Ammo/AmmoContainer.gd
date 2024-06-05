class_name AmmoContainer extends Node3D

@export var type: Inventory.PickupType = Inventory.PickupType.NONE

const MAX_AMMO: int = 50
var ammo: int = 50

func get_ammo() -> int:
	return ammo


func get_max_ammo() -> int:
	return MAX_AMMO


func get_type() -> Inventory.PickupType:
	return type


func remove_ammo(amount):
	if ammo - amount <= 0:
		ammo = 0
	else:
		ammo -= amount


func add_ammo(amount):
	if amount + ammo > MAX_AMMO:
		ammo = MAX_AMMO
	else:
		ammo += amount


func set_ammo(amount):
	if amount > MAX_AMMO:
		amount = MAX_AMMO
	ammo = amount


func reset():
	ammo = MAX_AMMO
