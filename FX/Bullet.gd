extends Area2D

class_name Bullet

var lifetime
var speed = 500

func create_bullet(life):
	lifetime = life
	connect("body_entered", on_body_entered)

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * speed * delta
	global_position.y += 5.0 * delta
	lifetime -= delta
	
	if lifetime <= 0:
		queue_free()

func on_body_entered(_body):
	queue_free()


func on_area_entered(area):
	print("area hit")
	if area.is_in_group("entity"):
		queue_free()
