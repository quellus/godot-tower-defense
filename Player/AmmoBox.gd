extends Node3D

const MAX_AMMO: int = 50
var ammo: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_ammo() -> int:
	return ammo
	
func remove_ammo(amount):
	if MAX_AMMO - ammo <= 0:
		ammo = 0
	else:
		ammo -= amount

func reset():
	ammo = MAX_AMMO
