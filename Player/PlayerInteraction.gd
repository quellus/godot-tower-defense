extends Area3D

@onready var inventory: Inventory = get_node("../Inventory")


func _ready():
	set_process_input(is_multiplayer_authority())

func _input(event):
	if event.is_action_pressed("fire"):
		_interact.rpc()
	
	elif event.is_action_pressed("drop_item"):
		_drop_item.rpc()


@rpc("authority", "call_local", "reliable")
func _interact():
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		var target = Global.get_closest(bodies, global_position)
		if target.is_in_group("tower"):
			_interact_with_tower(target)
		elif target.is_in_group("pickup"):
			inventory.pickup_item(target)
		elif target.is_in_group("ammo_stash") or target.is_in_group("charger"):
			if inventory.has_pickup():
				target.add_ammo_container(inventory.get_pickup_item())
			else:
				inventory.pickup_item(target.get_ammo_container())


@rpc("authority", "call_local", "reliable")
func _drop_item():
	inventory.drop_item()


func _interact_with_tower(tower: Tower):
	if inventory.has_pickup():
		if inventory.get_pickup_type() == tower.ammo_type:
			var item = inventory.get_pickup_item()
			inventory.item_taken(inventory.get_pickup_type())
			tower.add_ammo_container(item)

	else:
		var item = tower.get_ammo_container()
		if not item == null:
			inventory.pickup_item(item)

