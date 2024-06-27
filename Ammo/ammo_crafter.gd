extends StaticBody3D

signal crafting_done(ammo_container: AmmoContainer)
var ac_instance: AmmoContainer = null

@export var ammo_container: PackedScene
var crafting := false


func crafting_start(crafter: Node3D):
	if $ContainerHolder.get_child_count() <= 0:
		ac_instance = ammo_container.instantiate()
		$ContainerHolder.add_child(ac_instance)
	$Timer.start(1)
	if not crafter.crafting_end.is_connected(_on_crafting_end):
		crafter.crafting_end.connect(_on_crafting_end)
	crafting = true


func get_ammo_container() -> AmmoContainer:
	if ac_instance.get_ammo() >= ac_instance.get_max_ammo():
		var aci = ac_instance
		ac_instance = null
		crafting = false
		return aci
	return null


func _on_crafting_end(crafter_id):
	var player_list = get_tree().get_nodes_in_group("player")
	var crafter = null
	for player in player_list:
		if player.name == str(crafter_id):
			crafter = player.get_node("Area3D")
	if not crafter == null:
		crafting = false
		$Timer.stop()
		crafter.crafting_end.disconnect(_on_crafting_end)
	

func _on_timer_timeout():
	if crafting:
		ac_instance.add_ammo(10)
		if ac_instance.get_ammo() >= ac_instance.get_max_ammo():
			crafting_done.emit(get_ammo_container())
			crafting = false
			$Timer.stop()
