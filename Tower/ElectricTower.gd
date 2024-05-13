extends Tower

@onready var e_bullet_mat = load("res://Tower/ElectricBulletMaterial.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	#var bullet_mat = bullet.get_node("MeshInstance3d").get_active_material() as StandardMaterial3D
	#bullet_mat.albedo_color = Color(0,0,1,1)
	pass # Replace with function body.

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
					timer.start()
					enemy.damage(DamageType.electric, 1)
					ammo -= ammo_cost_per_shot
					audio_stream.play()

		enemyLocation.y = global_position.y
		look_at(enemyLocation, Vector3.UP)
		
	$SubViewport/ProgressBar.value = ammo

func get_closest(nodeList: Array, location: Vector3) -> Node:
	if nodeList.size() > 0:
		var closestNode = nodeList[0]
		var closestDist = location.distance_to(closestNode.global_position)
		for node in nodeList:
			var dist = location.distance_to(node.global_position)
			if dist < closestDist:
				closestNode = node
				closestDist = dist
		return closestNode
	return null

func add_ammo(amount) -> int:
	if (ammo < max_ammo):
		var empty = max_ammo - ammo
		var add = 0
		if empty > amount:
			add = amount
		else:
			add = amount - empty
		ammo += add
		return add
	return 0
