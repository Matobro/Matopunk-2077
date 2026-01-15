extends Weapon

class_name WEAPONNAME
func shoot(shooter_hitbox: HitComponent, shooter_type):
	for i in weapon_data.bullets:
		if weapon_data.has_ammo():
			## Spawn bullet
			spawn_bullet(barrel.global_rotation, shooter_hitbox, shooter_type)

			## Decrease gun ammo
			weapon_data.use_ammo()

			## Emit signal for ui
			emit_signal("magazine_changed", weapon_data.mag_left)

			emit_signal("shot_fired", weapon_data)

		else:
			return

    ## Play fx
	play_fx()
