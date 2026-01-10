extends Node

class_name SpawnWeapon

var weapon_pickup: PackedScene = preload("res://Weapons/Scenes/Base/WeaponPickUp.tscn")

@export var weapon_data: WeaponData

var spawn_pos: Vector2 = Vector2(280, -235)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("0"):
		spawn_weapon()

func spawn_weapon():
	## Create Weapon
	var weapon_instance: WeaponPickUp = weapon_pickup.instantiate()
	get_tree().current_scene.add_child(weapon_instance)

	## Assign weapon data to it
	weapon_instance.assign_weapon(weapon_data.duplicate(true))

	## Move it to player spawn
	weapon_instance.global_position = spawn_pos
