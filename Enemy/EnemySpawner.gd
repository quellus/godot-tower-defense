extends Node3D

@onready var path = get_node("/root/L_Main/Path3D")
@onready var first_point: Vector3 = path.curve.get_point_position(0)
@onready var enemy = load("res://Enemy/EnemyPathFollow.tscn")
@onready var enemies = get_node("/root/L_Main/Path3D")

func _ready():
	global_position = first_point

func _on_Timer_timeout():
	var enemyInstance = enemy.instantiate()
	enemies.add_child(enemyInstance)
	enemyInstance.global_translate(first_point)
