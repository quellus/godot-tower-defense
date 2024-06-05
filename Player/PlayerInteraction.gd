extends Area3D

@onready var inventory: Inventory = get_node("../Inventory")


func _input(event):
	if event.is_action_pressed("fire"):
		var bodies = get_overlapping_bodies()
		if bodies.size() > 0:
			print("interacting")
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
				
	elif event.is_action_pressed("drop_item"):
		inventory.drop_item()


func _interact_with_tower(tower: Tower):
	if inventory.has_pickup():
		if inventory.get_pickup_type() == tower.ammo_type:
			tower.add_ammo_container(inventory.get_pickup_item())

	else:
		var item = tower.get_ammo_container()
		if not item == null:
			inventory.pickup_item(item)
