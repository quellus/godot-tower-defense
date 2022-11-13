extends KinematicBody

onready var enemies: Spatial = get_node("/root/L_Main/Enemies")
var closestEnemy: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta) -> void:
	closestEnemy = get_closest(enemies.get_children(), global_translation)
	if closestEnemy:
		var enemyLocation = closestEnemy.global_translation
		enemyLocation.y = global_translation.y
		look_at(enemyLocation, Vector3.UP)

func get_closest(nodeList: Array, location: Vector3) -> Node:
	if nodeList.size() > 0:
		var closestNode = nodeList[0]
		var closestDist = location.distance_to(closestNode.global_translation)
		for node in nodeList:
			var dist = location.distance_to(node.global_translation)
			if dist < closestDist:
				closestNode = node
				closestDist = dist
		return closestNode
	return null
