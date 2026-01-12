extends Area2D
class_name InventoryComponent

# weapon_id -> WeaponData
var weapons: Dictionary = {}
var weapon_order: Array[String] = []
var current_index: int = -1

signal gained_weapon(weapon: WeaponData)
signal gained_ammo(weapon: WeaponData)


func _ready() -> void:
	connect("area_entered", try_pick_up)


func try_pick_up(pick_up: WeaponPickUp) -> void:
	if pick_up.is_in_group("WeaponPickup"):
		add_weapon_from_pick_up(pick_up)


func add_weapon_from_pick_up(pick_up: WeaponPickUp) -> void:
	if pick_up.weapon == null:
		return

	var weapon_id = pick_up.weapon.weapon_name

	# Already have weapon -> add ammo for now
	if has_weapon(weapon_id):
		var weapon = weapons[weapon_id]
		if !weapon.has_room_for_ammo():
			return

		weapon.add_ammo(weapon.repick_ammo_value)
		print(weapon.weapon_name)
		emit_signal("gained_ammo", weapon)
		pick_up.queue_free()
		return

	# New weapon
	var new_weapon = pick_up.weapon.duplicate(true)
	add_weapon(new_weapon)
	pick_up.queue_free()


func get_weapons_amount() -> int:
	return weapons.size()


func add_weapon(weapon: WeaponData) -> void:
	var id := weapon.weapon_name
	if weapons.has(id):
		return

	weapons[id] = weapon
	weapon_order.append(id)

	if current_index == -1:
		current_index = 0

	emit_signal("gained_weapon", weapon)


func has_weapon(id: String) -> bool:
	return weapons.has(id)


func get_weapon_by_index(index: int):
	if weapon_order.is_empty():
		return null	

	index = wrapi(index, 0, weapon_order.size())
	var id := weapon_order[index]
	return [weapons[id], index]
	

func get_next_weapon():
	return get_weapon_by_index(current_index + 1)


func get_previous_weapon():
	return get_weapon_by_index(current_index - 1)


func commit_equip(index):
	current_index = index
