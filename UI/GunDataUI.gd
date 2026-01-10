extends Control

class_name GunDataUI

@onready var gun_icon = $GunIcon
@onready var magazine_label = $Magazine
@onready var ammo_label = $Ammo
@onready var reload_bar = $ReloadBar


var is_reloading: bool = false

func _ready() -> void:
    show_gun_data(false)
    show_reload_bar(false)


func _process(delta: float) -> void:
    if is_reloading:
        reload_bar.value -= delta

    if reload_bar.value <= 0:
        is_reloading = false
        show_reload_bar(false)

func show_gun_data(value: bool = false):
    visible = value


func update_gun_icon(icon: Texture2D = null):
    gun_icon.texture = icon


func update_magazine_data(magazine_value: int = 0):
    magazine_label.text = str(magazine_value)


func update_ammo_data(ammo_value: int = 0):
    ammo_label.text = str(ammo_value)


func update_reload_bar(total_duration):
    is_reloading = true
    show_reload_bar(true)

    ## +0.2 is buffer, for some reason reload bar disappears slightly before reload is done
    reload_bar.max_value = total_duration + 0.2
    reload_bar.value = total_duration + 0.2


func show_reload_bar(value: bool = false):
    reload_bar.visible = value