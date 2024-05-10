extends PathFollow3D

var movement_speed: float = 0.1
	
func _physics_process(_delta) -> void:
	var parent = get_parent()
	if progress < parent.curve.get_baked_length():
		progress += movement_speed
	else:
		queue_free()
		
func damage(_amount):
	queue_free()
