extends GPUParticles3D

@onready var timer: Timer = get_node("Timer")
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(0.5)
	timer.one_shot = true

func _on_timer_timeout():
	if alive:
		alive = false
		emitting = false
		timer.start(2)
		timer.one_shot = true
	else:
		queue_free()
