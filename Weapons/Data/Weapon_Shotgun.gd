extends Weapon

class_name Shotgun

var bullet_spread: float = 15.0


func shoot():
    var bullet_amount = weapon_data.bullets

    if bullet_amount > weapon_data.mag_left:
        bullet_amount = weapon_data.mag_left

    if bullet_amount <= 0: return
    
    if weapon_data.bullets == 1:
        spawn_bullet(barrel.global_rotation)
        weapon_data.use_ammo()
        emit_signal("magazine_changed", weapon_data.mag_left)
        play_fx()
        return

    for i in bullet_amount:
        var spread_ratio: float = float(i) / float(bullet_amount - 1)
        var angle_offset: float = lerpf(-spread_ratio / 2.0, bullet_spread / 2.0, spread_ratio)
        spawn_bullet(barrel.global_rotation + deg_to_rad(angle_offset))
        weapon_data.use_ammo()
        emit_signal("magazine_changed", weapon_data.mag_left)
        play_fx()
    
    emit_signal("shot_fired", weapon_data)
