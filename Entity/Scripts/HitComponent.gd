extends Area2D

class_name HitComponent


@export var blood_particle: PackedScene


var gore_multiplier = 3.0


signal bullet_hit(damage)


func on_bullet_hit(damage: int, hit_position: Vector2, hit_direction: Vector2):
	emit_signal("bullet_hit", damage)

	for i in damage * gore_multiplier:
		spawn_blood(hit_position, hit_direction)


func spawn_blood(pos: Vector2, dir: Vector2):
	var blood: BloodParticle = blood_particle.instantiate()
	blood.global_position = pos

	var spray_dir = dir
	blood.rotation = spray_dir.angle()
	
	get_tree().current_scene.add_child(blood)


func set_collision_enabled(value: bool):
	monitorable = value
	monitoring = value
