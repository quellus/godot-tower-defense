extends AmmoContainer

@onready var battery_mesh: Mesh = $Battery.get_node("Battery").mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	battery_mesh.surface_set_material(3, StandardMaterial3D.new())
	_update_indicator()


func remove_ammo(amount):
	if ammo - amount <= 0:
		ammo = 0
	else:
		ammo -= amount
	_update_indicator()


func add_ammo(amount):
	if amount + ammo > MAX_AMMO:
		ammo = MAX_AMMO
	else:
		ammo += amount
	_update_indicator()


func _update_indicator():
	var battery_mesh = $Battery.get_node("Battery").mesh as Mesh
	var indicator_material = battery_mesh.surface_get_material(3)
	var ammo_ratio: float = float(ammo) / MAX_AMMO
	indicator_material.albedo_color = lerp(Color(1,0,0,1), Color(0,1,0,1),  ammo_ratio)
