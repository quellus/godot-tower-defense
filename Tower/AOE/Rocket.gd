extends PathFollow3D

@onready var explosion = load("res://Common/Explosion.tscn")

var target: Enemy
const MOVEMENT_SPEED: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#if target == null:
		#print("Rocket doesn't have a target and deleted itself")
		#queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var parent = get_parent()
	if progress < parent.curve.get_baked_length():
		var movement_speed = MOVEMENT_SPEED
		progress += movement_speed * delta
		print(progress)
	else:
		#TODO tell the path to free itself
		queue_free()
