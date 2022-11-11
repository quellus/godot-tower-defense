extends Spatial
var coords: Array = []
onready var map = get_node("/root/L_Main/GridMap")
onready var enemy = load("res://Enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta) -> void:
	coords = map.get_coords()
	var first_point = coords[0]

	


func _on_Timer_timeout():
	
	
	pass # Replace with function body.
