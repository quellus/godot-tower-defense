extends Tower

@export var rocket_path: PackedScene
@onready var rocket_spawn = get_node("RocketSpawnPoint")


# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.ROCKET
	ammo_type = Inventory.PickupType.ROCKET_BUNDLE
	ammo_cost_per_shot = 1
	firerate = 1
	on_ready()


func _physics_process(_delta) -> void:
	if ammo_holder.get_ammo() >= ammo_cost_per_shot:
		closestEnemy = Global.get_closest(enemies.get_children(), global_position)
		if closestEnemy:
			var enemyLocation = closestEnemy.global_position
			if timer.is_stopped() and closestEnemy.has_method("damage"):
					_instantiate_rocket_path(closestEnemy)
					timer.start(firerate)
					ammo_holder.remove_ammo(ammo_cost_per_shot)
					#audio_stream.play()

			enemyLocation.y = global_position.y
			look_at(enemyLocation, Vector3.UP)
	$SubViewport/ProgressBar.value = ammo_holder.get_ammo()


func _instantiate_rocket_path(enemy: Enemy):
	var rocket_path_instance = rocket_path.instantiate()
	rocket_path_instance.target = enemy
	get_tree().root.add_child(rocket_path_instance)
	rocket_path_instance.global_position = rocket_spawn.global_position
	rocket_path_instance.start()
