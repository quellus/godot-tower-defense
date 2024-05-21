extends Tower

@onready var rocket = load("res://Tower/AOE/Rocket.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.normal
	max_ammo = 20
	ammo = 20
	ammo_cost_per_shot = 1
	firerate = 1
	on_ready()


func _physics_process(_delta) -> void:
	closestEnemy = Global.get_closest(enemies.get_children(), global_position)
	if ammo > 0 and closestEnemy:
		var enemyLocation = closestEnemy.global_position
		raycast.look_at(enemyLocation, Vector3.UP)
		if raycast.is_colliding() && timer.is_stopped():
			if raycast.get_collider() && raycast.get_collider().get_parent():
				var enemy = raycast.get_collider().get_parent()
				if enemy.has_method("damage"):
					var rocket_instance = rocket.instantiate()
					rocket_instance.target = enemy
					get_tree().root.add_child(rocket_instance)
					rocket_instance.rotation = global_rotation
					rocket_instance.start_pos = global_position
					rocket_instance.start_pos += Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), global_rotation.y)
					rocket_instance.start_pos.y += 1
					timer.start(firerate)
					ammo -= ammo_cost_per_shot
					#audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.value = ammo
