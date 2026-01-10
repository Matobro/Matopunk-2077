extends Node
class_name GravityComponent


@export_category("Settings")
@export var GRAVITY: int = 100


var is_falling: bool = false


func apply_gravity(body: CharacterBody2D, delta: float):
    if !body.is_on_floor():
        body.velocity.y += GRAVITY * delta

    is_falling = body.velocity.y > 0 and !body.is_on_floor()