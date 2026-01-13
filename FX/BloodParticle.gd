extends Node2D

class_name BloodParticle


var speed = 50.0
var life_time = 5.0

var speed_variance = 200.0
var start_speed

var size_max = 0.1
var size_min = 0.02

var speed_y = 0.0

var min_speed_y = -1.0

func _ready() -> void:
	var rng_size = randf_range(size_min, size_max)
	$Sprite2D.scale = Vector2(rng_size, rng_size)

	var rng_speed = randf_range(speed - speed_variance, speed + speed_variance)
	speed = rng_speed
	speed = clampf(speed, 5, 1000)
	start_speed = speed

	speed_y = randf_range(min_speed_y, 0)

func _physics_process(delta):
	# Horizontal + initial direction movement
	global_position += Vector2.RIGHT.rotated(rotation) * speed * delta

	# Gravity (makes it fall more as it slows horizontally)
	var gravity := 1200.0      # pixels per second², tweak to your liking
	var drag := 0.9           # horizontal slowdown factor (0-1)

	# Apply horizontal drag
	speed *= pow(drag, delta)  # slows down horizontal movement over time

	var gravity_factor = 1.0 - clamp(speed / start_speed, 0, 1)
	global_position.y += speed_y + gravity * gravity_factor * delta

	# Reduce life time
	life_time -= delta
	if life_time <= 0:
		queue_free()
