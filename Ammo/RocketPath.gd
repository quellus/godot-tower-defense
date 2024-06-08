extends Path3D

@export var rocket_scene: PackedScene
var target: Enemy
var path_height = 10

func start():
	curve.add_point(global_position)
	var c1 = global_position
	c1.y += path_height
	curve.add_point(c1)
	var c2 = target.global_position
	c2.y += path_height
	curve.add_point(c2)
	curve.add_point(target.global_position)
	
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
	rocket.target = target
	rocket.global_position = global_position
