extends Area2D

class_name Bullet

var bullet_speed: float = 500
var bullet_lifetime: float = 5.0

var bullet_damage: int = 0

func initialize_bullet(bullet_data: BulletData, weapon_data: WeaponData):
	if bullet_data == null: 
		print("BulletData is null, destroying bullet")
		queue_free() 
		return

	$Sprite.texture = bullet_data.bullet_sprite

	var texture_size: Vector2 = $Sprite.texture.get_size()

	$CollisionShape2D.shape.size = texture_size

	bullet_speed = bullet_data.bullet_speed
	bullet_lifetime = bullet_data.bullet_lifetime
	bullet_damage = weapon_data.damage

	connect("body_entered", on_body_entered)
	connect("area_entered", on_area_entered)


func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * bullet_speed * delta
	global_position.y += 5.0 * delta
	bullet_lifetime -= delta
	
	if bullet_lifetime <= 0:
		queue_free()


func on_body_entered(body):
	if !body.is_in_group("entity"):
		queue_free()


func on_area_entered(area: Area2D):
	if area.is_in_group("entity"):

		var hit_position: Vector2 = global_position
		var hit_direction: Vector2 = Vector2.RIGHT.rotated(rotation)

		area.on_bullet_hit(bullet_damage, hit_position, hit_direction)
		queue_free()
