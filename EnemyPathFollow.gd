extends PathFollow

var movement_speed: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta) -> void:
	var parent = get_parent()
	if offset < parent.curve.get_baked_length():
		offset += movement_speed
	else:
		queue_free()
		
func damage(amount):
	queue_free()
