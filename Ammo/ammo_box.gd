extends AmmoContainer

@onready var ammo_box_mesh: Mesh = get_node("MeshInstance3D").mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	ammo = 0
	ammo_box_mesh.surface_set_material(0, StandardMaterial3D.new())
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
	var indicator_material = ammo_box_mesh.surface_get_material(0)
	var ammo_ratio: float = float(ammo) / MAX_AMMO
	indicator_material.albedo_color = lerp(Color(1,0,0,1), Color(0,1,0,1),  ammo_ratio)
