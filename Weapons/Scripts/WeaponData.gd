## Weapon 'data'

extends Resource

class_name WeaponData

@export_category("Weapon Data")
@export var weapon_name: String = "Weapon"
@export var weapon_scene = PackedScene
@export var weapon_sprite: Texture2D
@export var weapon_sprite_color: Color
@export var weapon_icon: Texture2D
@export var bullet: PackedScene
@export var bullet_data: BulletData

@export_category("Weapon Stats")
@export var cooldown: float = 0.5
@export var reload_time: float = 2.0
@export var mag_size: int = 20
@export var repick_ammo_value: int = 120
@export var max_ammo: int = 999
@export var damage: int = 1
@export var bullets: int = 1
@export var kick_strength: float = 10.0
@export var kick_fade_speed:float = 5.0

@export_category("Sounds")
@export var shoot: AudioStream
@export var reload: AudioStream

@export_category("FX")
@export var muzzle_effects: Array[PackedScene]
@export var muzzle_scale: float = 0.6

@export_category("AI")
@export var handicap_multiplier: float = 2.0

var ammo_total: int = 60
var mag_left: int = 1

var reloading: bool = false
var weapon_user: Node

var initialized: bool = false

func initialize_weapon() -> void:
    if initialized: return
    initialized = true
    mag_left = mag_size


## Returns reload state true/false
func is_reloading() -> bool:
    return reloading


## Returns if there is ammo in gun (mag not included)
func has_total_ammo() -> bool:
    return ammo_total > 0


## Returns how much ammo is left (mag not included)
func get_ammo() -> int:
    return ammo_total


## Returns true false if gun doesnt have max ammo already
func has_room_for_ammo() -> bool:
    return ammo_total < max_ammo


## Adds ammo to the gun (not mag)
func add_ammo(value: int = 0):
    ammo_total += value
    ammo_total = clampi(ammo_total, 0, max_ammo)


## Returns true/false if there is ammo in mag
func has_ammo() -> bool:
    return mag_left > 0


## Removes [value] from magazine
func use_ammo(value = 1):
    mag_left -= value
    clampi(mag_left, 0, mag_size)


func get_weapon_name() -> String:
    return weapon_name


func get_weapon_scene() -> PackedScene:
    return weapon_scene


func get_weapon_sprite() -> Texture2D:
    return weapon_sprite


func get_weapon_sprite_color() -> Color:
    return weapon_sprite_color


func get_weapon_icon() -> Texture2D:
    return weapon_icon


func get_weapon_bullet() -> PackedScene:
    return bullet


func get_weapon_cooldown() -> float:
    return cooldown


func get_weapon_damage() -> int:
    return damage