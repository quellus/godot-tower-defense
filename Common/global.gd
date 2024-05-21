extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func get_closest(nodeList: Array, location: Vector3) -> Node:
	if nodeList.size() > 0:
		var closestNode = nodeList[0]
		var closestDist = location.distance_to(closestNode.global_position)
		for node in nodeList:
			var dist = location.distance_to(node.global_position)
			if dist < closestDist:
				closestNode = node
				closestDist = dist
		return closestNode
	return null


func get_in_range(nodeList: Array, location: Vector3, distance: float) -> Array[Node]:
	var nodes = [] as Array[Node]
	if nodeList.size() > 0:
		for node in nodeList:
			if is_instance_valid(node):
				var dist = location.distance_to(node.global_position)
				if dist < distance:
					nodes.append(node)
		return nodes
	return nodes
