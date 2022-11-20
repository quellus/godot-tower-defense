extends PathFollow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta) -> void:
	var parent = get_parent()
	if offset < parent.curve.get_baked_length():
		offset += 0.3
	else:
		queue_free()
		
func damage(amount):
	queue_free()
