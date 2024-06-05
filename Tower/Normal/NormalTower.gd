extends Tower

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.NORMAL
	ammo_type = Inventory.PickupType.AMMO_BOX
	ammo_cost_per_shot = 1
	on_ready()


func _physics_process(_delta) -> void:
	closestEnemy = Global.get_closest(enemies.get_children(), global_position)
	if ammo_holder.get_ammo() > 0 and closestEnemy:
		var enemyLocation = closestEnemy.global_position
		raycast.look_at(enemyLocation, Vector3.UP)
		if raycast.is_colliding() && timer.is_stopped():
			if raycast.get_collider() && raycast.get_collider().get_parent():
				var enemy = raycast.get_collider().get_parent()
				if enemy.has_method("damage"):
					var bulletInstance = bullet.instantiate()
					bulletInstance.global_transform = raycast.global_transform
					get_node("/root/L_Main").add_child(bulletInstance)
					timer.start(firerate)
					enemy.damage(damage_type, 1)
					ammo_holder.remove_ammo(ammo_cost_per_shot)
					audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.max_value = ammo_holder.get_max_ammo()
	$SubViewport/ProgressBar.value = ammo_holder.get_ammo()
