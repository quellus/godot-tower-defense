extends Node3D

@onready var cam: Camera3D = get_node(NodePath("Camera3D"))
@onready var raycast: RayCast3D = get_node(NodePath("RayCast3D"))
@onready var towers: Node3D = get_node("/root/L_Main/Towers")
@onready var gridmap: GridMap = get_node("/root/L_Main/GridMap")
@onready var pickups: Pickups = get_node("../Pickups")

var ammo_pickup = preload("res://Ammo/ammo_box.tscn")
var battery_pickup = preload("res://Ammo/battery.tscn")

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()


func _physics_process(_delta) -> void:
	var pickup = pickups.pickup
	if raycast.is_colliding() and Input.is_action_just_pressed("fire"):
		_interact()
	elif pickup != Pickups.Pickup.NONE && Input.is_action_just_pressed("drop_item"):
		match pickup:
			Pickups.Pickup.AMMO_BOX:
				pickups.remove_ammo()
				var instance = ammo_pickup.instantiate()
				instance.type = Pickups.Pickup.AMMO_BOX
				get_tree().root.add_child(instance)
				instance.global_rotation = global_rotation
				instance.global_position = global_position
				instance.position += Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), global_rotation.y)
				instance.apply_central_impulse(Vector3(0, 0, -2).rotated(Vector3(0, 1, 0), global_rotation.y))
			Pickups.Pickup.BATTERY:
				var ammo = pickups.remove_battery()
				var instance = battery_pickup.instantiate()
				instance.type = Pickups.Pickup.BATTERY
				instance.set_ammo(ammo)
				get_tree().root.add_child(instance)
				instance.global_rotation = global_rotation
				instance.global_position = global_position
				instance.position += Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), global_rotation.y)
				instance.apply_central_impulse(Vector3(0, 0, -2).rotated(Vector3(0, 1, 0), global_rotation.y))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()


func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x


func _interact() -> void:
	var target = raycast.get_collider()
	var target_parent: Node = target.get_parent()
	if target.is_in_group("enemy") and target_parent.has_method("damage"): # enemy interaction
		target_parent.damage(Tower.DamageType.normal, 1)
	elif target.is_in_group("tower") and target.has_method("add_ammo"):
		var pickup = pickups.pickup
		if target.damage_type == Tower.DamageType.normal and pickup == pickups.Pickup.AMMO_BOX: # normal tower
			var ammo_box = get_node("../Pickups/AmmoBox")
			ammo_box.remove_ammo(ammo_box.get_ammo() - target.add_ammo(ammo_box.get_ammo()))
			if ammo_box.get_ammo() <= 0:
				pickups.remove_ammo()
		elif target.damage_type == Tower.DamageType.electric and target.has_method("has_battery"): # electric tower
			if pickup == pickups.Pickup.BATTERY:
				var battery = get_node("../Pickups/Battery")
				if !target.has_battery():
					target.add_ammo(battery.get_ammo())
					pickups.remove_battery()
			elif pickup == pickups.Pickup.NONE:
				if target.has_battery():
					pickups.pickup_battery(target.ammo)
					target.remove_battery()
	elif pickups.pickup == Pickups.Pickup.BATTERY:
		if target.is_in_group("charger"):
			var ammo = pickups.remove_battery()
			target.add_battery(ammo)
	elif pickups.pickup == pickups.Pickup.NONE:
		var ammo_box = get_node("../Pickups/AmmoBox")
		if target.is_in_group("pickup"): # pickup interaction
			if target.type == Pickups.Pickup.BATTERY:
				pickups.pickup_battery(target.get_ammo())
			elif target.type == Pickups.Pickup.AMMO_BOX:
				pickups.pickup_ammo(target.get_ammo())
			target.queue_free()
		elif target.is_in_group("ammo_stash"):
			pickups.pickup_ammo(ammo_box.MAX_AMMO)
		elif target.is_in_group("charger"):
			var ammo = target.remove_battery()
			pickups.pickup_battery(ammo)
