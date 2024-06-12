extends PathFollow3D

@onready var explosion = load("res://Common/Explosion.tscn")

var target: Enemy
const MOVEMENT_SPEED: float = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if progress + MOVEMENT_SPEED * delta < get_parent().curve.get_baked_length():
		progress += MOVEMENT_SPEED * delta
	else:
		var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
		var enemies_in_range = Global.get_in_range(enemies, global_position, 8)
		for enemy: Enemy in enemies_in_range:
			enemy.damage(Tower.DamageType.NORMAL, 2)
		var explo_instance = explosion.instantiate()
		get_tree().root.add_child(explo_instance)
		explo_instance.global_position = global_position
		
		get_parent().queue_free() # Delete the path and itself
