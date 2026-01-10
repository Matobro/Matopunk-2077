extends Area2D

class_name WeaponPickUp

@onready var sprite = $Sprite2D
var weapon: WeaponData

func assign_weapon(weapon_ref: WeaponData):
	weapon = weapon_ref
	sprite.texture = weapon.get_weapon_sprite()
	sprite.modulate = weapon.get_weapon_sprite_color()
