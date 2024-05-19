class_name Pickups extends Node3D

@onready var ammo_box: Node3D = get_node("AmmoBox")
@onready var battery: Node3D = get_node("Battery")

var pickup = Pickup.NONE

enum Pickup {
	AMMO_BOX,
	BATTERY,
	NONE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func pickup_battery(amount: int) -> void:
	battery.set_ammo(amount)
	battery.visible = true
	pickup = Pickup.BATTERY


func pickup_ammo(amount: int) -> void:
	ammo_box.set_ammo(amount)
	ammo_box.visible = true
	pickup = Pickup.AMMO_BOX


func remove_battery() -> void:
	battery.visible = false
	pickup = Pickup.NONE


func remove_ammo() -> void:
	ammo_box.visible = false
	pickup = Pickup.NONE
