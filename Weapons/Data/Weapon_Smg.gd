extends Weapon

func shoot():
	## Delay for 'burst' effect
	var delay = (weapon_data.cooldown / weapon_data.bullets) / 2
	delay = clampf(delay, 0.01, weapon_data.cooldown)

	## Spawn bullets in burst
	for i in weapon_data.bullets:
		if weapon_data.has_ammo():
			## Spawn bullet
			spawn_bullet(barrel.global_rotation)

			## Decrease gun ammo
			weapon_data.use_ammo()

			## Emit signal for ui
			emit_signal("magazine_changed", weapon_data.mag_left)

			emit_signal("shot_fired", weapon_data)

			## Timer for 'burst' effect
			await get_tree().create_timer(delay).timeout
		else:
			return

	play_fx()
