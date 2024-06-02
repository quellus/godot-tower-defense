extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("fire"):
		var bodies = get_overlapping_bodies()
		if bodies.size() > 0:
			var target = Global.get_closest(bodies, global_position)
			if target.is_in_group("tower"):
				_interact_with_tower(target)
			elif target.is_in_group("pickup"):
				_interact_with_pickup("pickup")
			else:
				# TODO implement interaction with other things like ammo stash and battery charger
				pass
	elif event.is_action_pressed("drop_item"):
		# TODO implement inventory system
		pass


func _interact_with_tower(target):
	# TODO implement this
	print("interacting with tower")
	target.add_ammo(50)
	pass


func _interact_with_pickup(target):
	# TODO implement this
	print("interacting with pickup")
	pass
