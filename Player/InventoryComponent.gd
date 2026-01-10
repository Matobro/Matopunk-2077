extends Area2D

class_name InventoryComponent

var weapons: Array[WeaponData]

signal gained_weapon(weapon: WeaponData)
signal gained_ammo(weapon: WeaponData)

func _ready() -> void:
	connect("area_entered", try_pick_up)


func try_pick_up(pick_up: WeaponPickUp):
	if pick_up.is_in_group("WeaponPickup"):
		add_weapon_from_pick_up(pick_up)


func add_weapon(weapon: WeaponData):
	weapons.append(weapon)


func add_weapon_from_pick_up(pick_up: WeaponPickUp):
	if pick_up.weapon == null:
		return

	var check_pick_up = has_weapon(pick_up.weapon.weapon_name)
	if check_pick_up != null:
		if !check_pick_up.has_room_for_ammo(): return
		check_pick_up.add_ammo(check_pick_up.repick_ammo_value)
		emit_signal("gained_ammo", check_pick_up)
		pick_up.queue_free()
		return

	var weapon = pick_up.weapon
	add_weapon(weapon)
	emit_signal("gained_weapon", weapon)
	pick_up.queue_free()


func equip_weapon_by_index(index):
	if weapons[index] == null: return

	var weapon = weapons[index]
	equip_weapon(weapon)
	

func equip_weapon(weapon: WeaponData):
	return weapon


func get_weapons_amount() -> int:
	return weapons.size()


func has_weapon(id) -> Variant:
	for weapon in weapons:
		if weapon.weapon_name == id:
			return weapon as WeaponData
	return null
