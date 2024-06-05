extends Area3D

@onready var explosion = load("res://Common/Explosion.tscn")

var target: Enemy

var time_left: float
var total_time = 2
var peak_height: float
var start_pos: Vector3
var target_pos = Vector3(0,0,0)
var distance
var is_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if target == null:
		print("Rocket doesn't have a target and deleted itself")
		queue_free()


func _physics_process(delta):
	if is_started:
		if time_left > 0.001:
			var time_left_ratio = (time_left / total_time)
			var p1 = start_pos
			p1.y += peak_height
			var p2 = target_pos
			p2.y += peak_height
			var next_position = start_pos.bezier_interpolate(p1, p2, target_pos, 1 - time_left_ratio)
			look_at(next_position + Vector3(0.001, 0, 0), Vector3.UP)
			position = next_position
			
			time_left = time_left - delta
		else:
			var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
			var enemies_in_range = Global.get_in_range(enemies, global_position, 8)
			for enemy: Enemy in enemies_in_range:
				enemy.damage(Tower.DamageType.NORMAL, 2)
			var explo_instance = explosion.instantiate()
			explo_instance.position = position
			get_tree().root.add_child(explo_instance)
			queue_free()


func start():
	target_pos = target.global_position
	time_left = total_time
	distance = start_pos.distance_to(target_pos)
	peak_height = distance / 1.5
	is_started = true
