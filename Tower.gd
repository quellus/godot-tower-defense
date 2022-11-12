extends KinematicBody

onready var enemies: Spatial = get_node("/root/L_Main/Enemies")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta) -> void:
	var closestEnemy: Node = get_closest(enemies.get_children(), global_translation)
	if closestEnemy:
		look_at(closestEnemy.global_translation, Vector3.UP)

func get_closest(nodeList: Array, location: Vector3) -> Node:
	if nodeList.size() > 0:
		var closestNode = nodeList[0]
		var closestDist = location.distance_to(closestNode.global_translation)
		return closestNode
	return null
