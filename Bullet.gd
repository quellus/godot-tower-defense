extends Spatial

#onready var timer: Timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Timer_timeout():
	queue_free()
