extends Tower

@onready var e_bullet_mat = load("res://Tower/Electric/ElectricBulletMaterial.tres")

var battery = true

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.ELECTRIC
	ammo_type = Inventory.PickupType.BATTERY
	firerate = 2
	ammo_cost_per_shot = 10
	on_ready()


func _physics_process(_delta) -> void:
	closestEnemy = Global.get_closest(enemies.get_children(), global_position)
	if ammo_holder.get_ammo() > 0 and closestEnemy:
		var enemyLocation = closestEnemy.global_position
		raycast.look_at(enemyLocation, Vector3.UP)
		if raycast.is_colliding() && timer.is_stopped():
			if raycast.get_collider() && raycast.get_collider().get_parent():
				var enemy = raycast.get_collider().get_parent()
				if ammo_holder.get_ammo() > 0 and enemy.has_method("damage"):
					var bulletInstance = bullet.instantiate()
					bulletInstance.global_transform = raycast.global_transform
					get_node("/root/L_Main").add_child(bulletInstance)
					bulletInstance.get_node("MeshInstance3D").set_surface_override_material(0, e_bullet_mat)
					timer.start(firerate)
					enemy.damage(damage_type, 0)
					ammo_holder.remove_ammo(ammo_cost_per_shot)
					audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.value = ammo_holder.get_ammo()


func has_battery() -> bool:
	return battery


func remove_battery() -> int:
	if has_battery():
		var bat_ammo = ammo_holder.get_ammo()
		battery = false
		get_node("Battery").visible = false
		return bat_ammo
	return 0
