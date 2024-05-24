extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("fire"):
		var bodies = get_overlapping_bodies()
		if bodies.size() > 0:
			print("interacting")
			var target = Global.get_closest(bodies, global_position)
