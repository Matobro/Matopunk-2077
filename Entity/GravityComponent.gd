extends Node
class_name GravityComponent


@export_category("Dependencies")
@export var floor_ray: RayCast2D

@export_category("Settings")
@export var GRAVITY: int = 100


var is_falling: bool = false


func apply_gravity(body: CharacterBody2D, delta: float):
	if !body.is_on_floor():
		body.velocity.y += GRAVITY * delta

	is_falling = body.velocity.y > 0 and !body.is_on_floor()


func is_grounded(body) -> bool:
	return body.is_on_floor()


func is_on_one_way_platform(body: CharacterBody2D) -> bool:
	if floor_ray.is_colliding():
		var collider = floor_ray.get_collider()
		if collider.collision_layer & (1 << 4):
			return true
	return false
