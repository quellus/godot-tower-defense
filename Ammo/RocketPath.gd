extends Path3D

@export var rocket_scene: PackedScene
var target: Enemy
var peak_height = 10

func start():
	peak_height = (global_position.distance_to(target.global_position) * 0.4) - 1.1
	curve = Curve3D.new()
	var p1 = Vector3(0,0,0)
	var p2 = to_local(target.global_position)
	var c1 = (p1+p2)/3 - p1
	c1.y = c1.y + peak_height
	var c2 = ((p1+p2)*2)/3 - p2
	c2.y = c2.y + peak_height
	curve.add_point(p1, Vector3(0,0,0), c1)
	curve.add_point(p2, c2)
	
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
