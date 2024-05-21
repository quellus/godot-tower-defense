class_name Tower extends CharacterBody3D

@onready var enemies: Node3D = get_node("/root/L_Main/Path3D")
@onready var raycast: RayCast3D = get_node("RayCast3D")
@onready var bullet = load("res://Tower/Common/Bullet.tscn")
@onready var timer = get_node("Timer")
@onready var audio_stream: AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")

enum DamageType { normal, electric, aoe }

var damage_type: DamageType
var closestEnemy: Node = null

var max_ammo = 100
var ammo = 50
var ammo_cost_per_shot = 10
var firerate = 1

func on_ready():
	$SubViewport/ProgressBar.max_value = max_ammo
	$SubViewport/ProgressBar.value = ammo


func add_ammo(amount) -> int:
	if (ammo < max_ammo):
		var empty = max_ammo - ammo
		var add = 0
		if empty > amount:
			add = amount
		else:
			add = empty
		ammo += add
		return add
	return 0
