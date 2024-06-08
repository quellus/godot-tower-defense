extends Path3D

@export var rocket_scene: PackedScene
var target: Enemy
var path_height = 5

func start():
	curve = Curve3D.new()
	curve.add_point(Vector3(0,0,0))
	var c1 = curve.get_point_position(0)
	c1.y += path_height
	curve.add_point(c1)
	var c2 = to_local(target.global_position)
	c2.y += path_height
	curve.add_point(c2)
	curve.add_point(to_local(target.global_position))
	curve.tessellate(5)
	set_curve(curve)
	
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
	rocket.target = target
