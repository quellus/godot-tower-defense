extends Spatial

onready var path = get_node("/root/L_Main/Path")
onready var first_point: Vector3 = path.curve.get_point_position(0)
onready var enemy = load("res://Enemy/EnemyPathFollow.tscn")
onready var enemies = get_node("/root/L_Main/Path")

func _ready():
	global_translation = first_point

func _on_Timer_timeout():
	var enemyInstance = enemy.instance()
	enemies.add_child(enemyInstance)
	enemyInstance.global_translate(first_point)
