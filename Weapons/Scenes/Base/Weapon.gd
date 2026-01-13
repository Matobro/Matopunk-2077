extends Node2D

class_name Weapon


var weapon_data: WeaponData
var bullet_data: BulletData
@onready var barrel = $Barrel

signal magazine_changed(magazine: int)
signal shot_fired(weapon: WeaponData)

func shoot():
	pass

func spawn_bullet(bullet_rotation: float):
	var bullet_instance: Bullet = weapon_data.bullet.instantiate()

	## Setup transform
	bullet_instance.rotation = bullet_rotation
	bullet_instance.global_position = barrel.global_position

	## Setup bullet
	bullet_instance.initialize_bullet(bullet_data, weapon_data)
	get_tree().current_scene.add_child(bullet_instance)


func play_fx():
	## Play FX
	var muzzle_flash = weapon_data.muzzle_effects[randi() % weapon_data.muzzle_effects.size()].instantiate()
	muzzle_flash.rotation = barrel.global_rotation
	muzzle_flash.global_position = barrel.global_position
	muzzle_flash.scale = Vector2(weapon_data.muzzle_scale, weapon_data.muzzle_scale)
	get_tree().current_scene.add_child(muzzle_flash)