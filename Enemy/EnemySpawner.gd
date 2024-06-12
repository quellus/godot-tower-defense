extends Node3D

@onready var path = get_node("/root/L_Main/Path3D")
@onready var first_point: Vector3 = path.curve.get_point_position(0)
@onready var enemy = load("res://Enemy/EnemyPathFollow.tscn")
@onready var enemies = get_node("/root/L_Main/Path3D")
@onready var waveTimer = get_node("WaveTimer")

const ENEMIES_PER_WAVE = 5
var enemies_this_wave = 5
var current_enemies = 0

func _ready():
	global_position = first_point

func _on_spawn_timer_timeout():
	if enemies_this_wave >= 1:
		var enemyInstance = enemy.instantiate()
		enemyInstance.connect("enemy_died", _on_enemy_died)
		enemies.add_child(enemyInstance)
		enemyInstance.global_translate(first_point)
		enemies_this_wave -= 1
		current_enemies += 1

func _on_wave_timer_timeout():
	enemies_this_wave = ENEMIES_PER_WAVE

func _on_enemy_died():
	current_enemies -= 1
	if current_enemies <= 0 && enemies_this_wave == 0:
		waveTimer.start(5)
		enemies_this_wave = 0
