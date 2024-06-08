extends PathFollow3D

@onready var explosion = load("res://Common/Explosion.tscn")

var target: Enemy
const MOVEMENT_SPEED: float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector3(0,0,0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var parent = get_parent()
	if progress < parent.curve.get_baked_length():
		var movement_speed = MOVEMENT_SPEED
		progress += movement_speed * delta
	else:
		#TODO tell the path to free itself
		print("rocket hit end")
		queue_free()
