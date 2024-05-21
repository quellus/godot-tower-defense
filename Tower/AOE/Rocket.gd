extends Area3D

var target: Enemy

var time_left: float
var total_time = 2
var peak_height = 10
var start_pos
var target_pos = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	if target == null:
		print("Rocket doesn't have a target and deleted itself")
		queue_free()
	start_pos = global_position
	target_pos = target.global_position
	time_left = total_time


func _physics_process(delta):
	if time_left > 0.001:
		var time_left_ratio = (time_left / total_time)
		var p1 = start_pos
		p1.y += 10
		var p2 = target_pos
		p2.y += 10
		position = start_pos.bezier_interpolate(p1, p2, target_pos, 1 - time_left_ratio)
		
		time_left = time_left - delta
	else:
		var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
		var enemies_in_range = Global.get_in_range(enemies, global_position, 8)
		for enemy: Enemy in enemies_in_range:
			enemy.damage(Tower.DamageType.normal, 2)
		queue_free()
