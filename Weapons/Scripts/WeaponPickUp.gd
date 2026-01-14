extends Area2D

class_name WeaponPickUp

@onready var sprite = $Sprite2D
@export var weapon: WeaponData

@export var is_debug: bool = false

func _ready():
	if is_debug:
		assign_weapon(weapon)

func assign_weapon(weapon_ref: WeaponData):
	weapon = weapon_ref.duplicate(true)
	sprite.texture = weapon.get_weapon_sprite()
	sprite.modulate = weapon.get_weapon_sprite_color()
