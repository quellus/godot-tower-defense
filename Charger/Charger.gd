extends Node3D

@onready var battery_holder: AmmoHolder = get_node("BatteryHolder")
@onready var timer: Timer = get_node("Timer")

var charge_rate: int = 10

func add_ammo_container(target: AmmoContainer) -> void:
	timer.start(1)
	timer.one_shot = true
	battery_holder.add_ammo_container(target)


func get_ammo_container() -> AmmoContainer:
	return battery_holder.get_ammo_container()


func _on_timer_timeout():
	if battery_holder.has_ammo_container():
		get_ammo_container().add_ammo(charge_rate)
		print(battery_holder.get_ammo())
		timer.start(1)
		timer.one_shot = true
