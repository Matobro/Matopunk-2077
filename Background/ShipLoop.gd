extends Node2D

class_name BackGroundShip


@export var speed := 30.0
@export var sprite: Sprite2D
@export var move_left: bool = true

var spawn_position


func _ready() -> void:
	randomize()


func set_movement_direction(value: int):
	if value == 0:
		sprite.flip_h = true
		move_left = false
	else:
		sprite.flip_h = false
		move_left = true


func _process(delta):
	if move_left:
		position.x -= speed * delta
	else:
		position.x += speed * delta


func randomize_appearance(ship_variances):
	var selected_skin_index = randi() % ship_variances.size()
	var selected_skin = ship_variances[selected_skin_index]
	sprite.texture = selected_skin


func randomize_size(min, max):
	var rng_scale = randf_range(min, max)
	sprite.scale = Vector2(rng_scale, rng_scale)


func randomize_speed(min, max):
	speed = randf_range(min, max)


func set_color(color: Color, use_color: bool):
	if !use_color: return
	sprite.modulate = color


func set_layer(layer: int):
	z_index = layer
