extends Tower

@onready var e_bullet_mat = load("res://Tower/ElectricBulletMaterial.tres")

var battery = true

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_type = DamageType.electric
	firerate = 2
	max_ammo = 50
	ammo = 50
	ammo_cost_per_shot = 10
	$SubViewport/ProgressBar.max_value = max_ammo
	$SubViewport/ProgressBar.value = ammo


func _physics_process(_delta) -> void:
	closestEnemy = get_closest(enemies.get_children(), global_position)
	if closestEnemy:
		var enemyLocation = closestEnemy.global_position
		raycast.look_at(enemyLocation, Vector3.UP)
		if raycast.is_colliding() && timer.is_stopped():
			if raycast.get_collider() && raycast.get_collider().get_parent():
				var enemy = raycast.get_collider().get_parent()
				if ammo > 0 and enemy.has_method("damage"):
					var bulletInstance = bullet.instantiate()
					bulletInstance.global_transform = raycast.global_transform
					get_node("/root/L_Main").add_child(bulletInstance)
					bulletInstance.get_node("MeshInstance3D").set_surface_override_material(0, e_bullet_mat)
					timer.start(firerate)
					enemy.damage(DamageType.electric, 0)
					ammo -= ammo_cost_per_shot
					audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.value = ammo


func has_battery() -> bool:
	return battery


func remove_battery() -> int:
	if has_battery():
		var bat_ammo = ammo
		ammo = 0
		battery = false
		get_node("Battery").visible = false
		return bat_ammo
	return 0


func add_ammo(amount) -> int:
	if !battery:
		battery = true
		get_node("Battery").visible = true
	if (ammo < max_ammo):
		var empty = max_ammo - ammo
		var add = 0
		if empty > amount:
			add = amount
		else:
			add = empty
		ammo += add
		return add
	return 0
