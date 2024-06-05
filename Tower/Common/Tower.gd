class_name Tower extends CharacterBody3D

@onready var enemies: Node3D = get_node("/root/L_Main/Path3D")
@onready var raycast: RayCast3D = get_node("RayCast3D")
@onready var bullet = load("res://Tower/Common/Bullet.tscn")
@onready var timer = get_node("Timer")
@onready var audio_stream: AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")
@onready var ammo_holder = get_node("AmmoHolder")

enum DamageType { NORMAL, ELECTRIC, ROCKET }

var damage_type: DamageType
var ammo_type: Inventory.PickupType
var closestEnemy: Node = null

var ammo_cost_per_shot = 10
var firerate = 1

func on_ready():
	$SubViewport/ProgressBar.max_value = ammo_holder.get_max_ammo()
	$SubViewport/ProgressBar.value = ammo_holder.get_ammo()


func add_ammo_container(target: AmmoContainer) -> void:
	ammo_holder.add_ammo_container(target)


func get_ammo_container() -> AmmoContainer:
	if ammo_holder.get_child_count() >= 1:
		return ammo_holder.get_child(0)
	else:
		return null
