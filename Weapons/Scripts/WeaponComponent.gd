extends Node2D

class_name WeaponComponent

var current_weapon: Weapon

var can_shoot: bool = true
var is_reloading: bool = false

var cooldown_timer: float = 0.0
var reload_timer: float = 0.0
var reload_time: float = 0.0

signal magazine_changed(magazine: int)
signal ammo_changed(ammo: int)
signal weapon_changed(weapon: Weapon)
signal reloading(total_duration)
signal shot_fired(data: WeaponData)
signal reload_done(data: WeaponData, was_cancelled: bool)
signal reload_progress(remaining: float, total: float)


func swap_weapon(weapon_data: WeaponData):
	if current_weapon != null:
		current_weapon.disconnect("magazine_changed", on_magazine_changed)
		current_weapon.disconnect("shot_fired", on_shot_fired)
		current_weapon.queue_free()

	cancel_reload()
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


func _physics_process(delta: float) -> void:
	if !can_shoot:
		if cooldown_timer > 0:
			cooldown_timer -= delta
		else:
			can_shoot = true

	if is_reloading:
		if reload_timer > 0:
			reload_timer -= delta
			emit_signal("reload_progress", reload_timer, reload_time)

		if reload_timer <= 0:
			is_reloading = false
			on_reload_done()


func try_shoot():
	if !current_weapon or !can_shoot: return
	if is_reloading: return

	if !current_weapon.weapon_data.has_ammo():
		reload()
		return
		
	shoot()


func shoot():
	cooldown_timer = current_weapon.weapon_data.get_weapon_cooldown()
	can_shoot = false
	current_weapon.shoot()


func on_shot_fired(data: WeaponData):
	emit_signal("shot_fired", data)


func on_magazine_changed(magazine: int):
	emit_signal("magazine_changed", magazine)


func cancel_reload():
	is_reloading = false
	reload_timer = 0.0
	emit_signal("reload_done", null, true)


func reload():
	if is_reloading or !current_weapon: return

	var data: WeaponData = current_weapon.weapon_data
	var ammo_missing: int = data.mag_size - data.mag_left

	if ammo_missing <= 0 or !data.has_total_ammo(): return

	is_reloading = true
	reload_time = data.reload_time
	reload_timer = data.reload_time

	emit_signal("reloading", data.reload_time)


func on_reload_done():
	var data: WeaponData = current_weapon.weapon_data
	var ammo_missing: int = data.mag_size - data.mag_left
	var temp_ammo: int = data.ammo_total
	var temp_mag: int = data.mag_left

	var transfer = min(ammo_missing, data.ammo_total)
	data.mag_left += transfer
	data.ammo_total -= transfer

	emit_signal("magazine_changed", data.mag_left)
	emit_signal("ammo_changed", data.ammo_total)
	emit_signal("reload_done", data, false)
	is_reloading = false