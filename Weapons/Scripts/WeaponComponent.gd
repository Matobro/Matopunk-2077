extends Node2D

class_name WeaponComponent

var current_weapon: Weapon

var can_shoot: bool = true
var is_reloading: bool = false

var cooldown_timer: float = 0.0

signal magazine_changed(magazine: int)
signal ammo_changed(ammo: int)
signal weapon_changed(weapon: Weapon)
signal reloading(total_duration)
signal shot_fired(data: WeaponData)
signal reload_done(data: WeaponData)

func swap_weapon(weapon_data: WeaponData):
	if current_weapon != null:
		current_weapon.disconnect("magazine_changed", on_magazine_changed)
		current_weapon.disconnect("shot_fired", on_shot_fired)
		current_weapon.queue_free()

	## Spawn weapon	
	current_weapon = weapon_data.get_weapon_scene().instantiate()
	current_weapon.weapon_data = weapon_data
	current_weapon.weapon_data.initialize_weapon()
	add_child(current_weapon)

	## Setup signal for ui ammo change
	current_weapon.connect("magazine_changed", on_magazine_changed)
	current_weapon.connect("shot_fired", on_shot_fired)
	emit_signal("ammo_changed", current_weapon.weapon_data.ammo_total)
	emit_signal("magazine_changed", current_weapon.weapon_data.mag_left)
	emit_signal("weapon_changed", current_weapon)


func _process(delta: float) -> void:
	if !can_shoot:
		if cooldown_timer > 0:
			cooldown_timer -= delta
		else:
			can_shoot = true

func try_shoot():
	if !current_weapon or !can_shoot: return
	if is_reloading: return

	if !current_weapon.weapon_data.has_ammo():
		reload()
		
	shoot()


func shoot():
	cooldown_timer = current_weapon.weapon_data.get_weapon_cooldown()
	can_shoot = false
	current_weapon.shoot()


func on_shot_fired(data: WeaponData):
	emit_signal("shot_fired", data)


func on_magazine_changed(magazine: int):
	emit_signal("magazine_changed", magazine)


func reload():
	if is_reloading or !current_weapon: return
	var data: WeaponData = current_weapon.weapon_data
	var temp_ammo: int = data.ammo_total
	var temp_mag: int = data.mag_left
	var ammo_missing: int = data.mag_size - data.mag_left

	if ammo_missing <= 0 or !data.has_total_ammo(): return

	if temp_ammo <= 0:
		is_reloading = false
		return

	for i in ammo_missing:
		if temp_mag < data.mag_size:
			if temp_ammo > 0:
				temp_ammo -= 1
				temp_mag += 1

	is_reloading = true
	emit_signal("reloading", data.reload_time)
	await get_tree().create_timer(data.reload_time).timeout
	data.mag_left = temp_mag
	data.ammo_total = temp_ammo
	emit_signal("magazine_changed", data.mag_left)
	emit_signal("ammo_changed", data.ammo_total)
	emit_signal("reload_done", data)
	is_reloading = false
