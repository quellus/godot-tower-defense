extends PathFollow3D

signal enemy_died

var movement_speed: float = 0.1
	
func _physics_process(_delta) -> void:
	var parent = get_parent()
	if progress < parent.curve.get_baked_length():
		progress += movement_speed
	else:
		emit_signal("enemy_died")
		queue_free()
		
func damage(_amount):
	emit_signal("enemy_died")
	queue_free()
