extends KinematicBody

onready var enemies: Spatial = get_node("/root/L_Main/Path")
onready var raycast: RayCast = get_node("RayCast")
onready var bullet = load("res://Tower/Bullet.tscn")
onready var timer = get_node("Timer")
onready var audio_stream: AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")

var closestEnemy: Node = null
var timerReady = true

const max_ammo = 100
var ammo = 50
const ammo_cost_per_shot = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta) -> void:
	closestEnemy = get_closest(enemies.get_children(), global_translation)
	if closestEnemy:
		var enemyLocation = closestEnemy.global_translation
		raycast.look_at(enemyLocation, Vector3.UP)
		if raycast.is_colliding() && timer.is_stopped():
			var enemy = raycast.get_collider().get_parent()
			if ammo > 0 and enemy.has_method("damage"):
				var bulletInstance = bullet.instance()
				bulletInstance.global_transform = raycast.global_transform
				get_node("/root/L_Main").add_child(bulletInstance)
				timer.start()
				enemy.damage(1)
				ammo -= ammo_cost_per_shot
				audio_stream.play()

		enemyLocation.y = global_translation.y
		look_at(enemyLocation, Vector3.UP)
		
	$Viewport/ProgressBar.value = ammo

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

func add_ammo(amount) -> int:
	if (ammo < max_ammo):
		var empty = max_ammo - ammo
		var add = 0
		if empty > amount:
			add = amount
		else:
			add = amount - empty
		ammo += add
		return add
	return 0
