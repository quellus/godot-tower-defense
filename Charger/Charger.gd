extends Node3D

@onready var battery = get_node("Battery")
@onready var timer = get_node("Timer")

var has_battery = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta) -> void:
	if has_battery:
		if timer.is_stopped():
			timer.start(1)
			timer.one_shot = true
			battery.set_ammo(battery.get_ammo() + 10)
			print(battery.get_ammo())


func add_battery(amount) -> void:
	if not has_battery:
		has_battery = true
		battery.visible = true
		battery.set_ammo(amount)
	
	
func remove_battery() -> int:
	if has_battery:
		has_battery = false
		battery.visible = false
		return battery.get_ammo()
	return 0
