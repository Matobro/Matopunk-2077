extends Area2D

class_name HitComponent


@export var blood_particle: PackedScene


var gore_multiplier = 5.0


signal bullet_hit(damage)


func on_bullet_hit(damage: int, hit_position: Vector2, hit_direction: Vector2):
	emit_signal("bullet_hit", damage)

	for i in damage * gore_multiplier:
		spawn_blood(hit_position, hit_direction, damage)


func spawn_blood(pos: Vector2, dir: Vector2, damage: int):
	var blood: BloodParticle = blood_particle.instantiate()
	blood.global_position = pos
	blood.speed = blood.speed * (damage / 15.0)

	var spray_dir = dir
	blood.rotation = spray_dir.angle()
	
	get_tree().current_scene.add_child(blood)


func set_collision_enabled(value: bool):
	monitorable = value
	monitoring = value
