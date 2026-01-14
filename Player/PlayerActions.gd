extends Node

class_name PlayerActions

@export_category("Dependencies")
@export var gun_data_ui: GunDataUI
@export var health_ui: HealthUI
@export var sound_player: SoundPlayer
@export var camera: PlayerCamera

func weapon_changed(weapon: Weapon):
	gun_data_ui.update_gun_icon(weapon.weapon_data.weapon_icon)


func ammo_changed(ammo: int):
	gun_data_ui.update_ammo_data(ammo)


func magazine_changed(magazine: int):
	gun_data_ui.update_magazine_data(magazine)


func reloading(total_duration):
	gun_data_ui.update_reload_bar(total_duration)


func reload_progress(remaining, total):
	gun_data_ui.update_reload_progress(remaining)


func gained_ammo(weapon: WeaponData, current_weapon: Weapon):
	if weapon == current_weapon.weapon_data:
		ammo_changed(weapon.get_ammo())


func reload_done(data: WeaponData, cancelled: bool = false):
	gun_data_ui.show_reload_bar(false)
	if cancelled: return

	sound_player.play_audio(data.reload)


func shot_fired(data: WeaponData):
	sound_player.play_audio(data.shoot)
	camera.apply_camera_shake(data.kick_strength, data.kick_fade_speed)


func on_current_health_changed(new_value: int):
	health_ui.update_current_health(new_value)


func on_max_health_changed(health: int):
	health_ui.update_max_health(health)
