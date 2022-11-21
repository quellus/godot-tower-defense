extends Spatial
var coords: Array = []
onready var path = get_node("/root/L_Main/Path")
onready var timer = get_node("Timer")
onready var enemy = load("res://EnemyPathFollow.tscn")
onready var enemies = get_node("/root/L_Main/Path")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta) -> void:
	var first_point: Vector3 = path.curve.get_point_position(0)
	global_translation = first_point

func _on_Timer_timeout():
	var enemyInstance = enemy.instance()
	var first_point: Vector3 = path.curve.get_point_position(0)
	enemies.add_child(enemyInstance)
	enemyInstance.global_translate(first_point)
	pass # Replace with function body.
