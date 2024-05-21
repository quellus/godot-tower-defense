class_name Enemy extends PathFollow3D

signal enemy_died

const MOVEMENT_SPEED: float = 0.1
const SLOWED_MOVEMENT_SPEED: float = 0.01
var is_slowed: bool = false
var health = 5

func _physics_process(_delta) -> void:
	var parent = get_parent()
	if progress < parent.curve.get_baked_length():
		var movement_speed = MOVEMENT_SPEED
		if is_slowed:
			movement_speed = SLOWED_MOVEMENT_SPEED
		progress += movement_speed
	else:
		emit_signal("enemy_died")
		queue_free()


func damage(damage_type: Tower.DamageType, amount):
	if damage_type == Tower.DamageType.electric:
			var debuff_timer = get_node("DebuffTimer")
			debuff_timer.one_shot = true
			debuff_timer.start(2)
			is_slowed = true
	health -= amount
	if health <= 0:
		queue_free()
		emit_signal("enemy_died")


func _on_debuff_timeout():
	is_slowed = false
