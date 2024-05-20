extends Tower

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.normal
	max_ammo = 20
	ammo = 20
	ammo_cost_per_shot = 1
	on_ready()


func _physics_process(_delta) -> void:
	closestEnemy = get_closest(enemies.get_children(), global_position)
	if ammo > 0 and closestEnemy:
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
					enemy.damage(DamageType.normal, 1)
					ammo -= ammo_cost_per_shot
					audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.value = ammo
