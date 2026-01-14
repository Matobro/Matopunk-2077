extends Area2D

class_name SightComponent


var sight_box: CollisionPolygon2D

@export_category("Sight Settings")
@export var sight_range: float = 400.0
@export var sight_height: float = 50.0
@export var check_speed: float = 1.0

@export_category("Debug")
@export var debug_draw: bool = false

var targets_in_sight: Array

var check_timer: float = 0.0


signal spotted_target(player: Player)

func _ready() -> void:
	sight_box = $CollisionPolygon2D
	setup_sight_radius()

	area_entered.connect(on_area_enter)
	area_exited.connect(on_area_exited)


func _physics_process(delta: float) -> void:
	if check_timer < check_speed:
		check_timer += delta

		if check_timer >= check_speed:
			check_timer = 0.0
			ray_check()


func setup_sight_radius():
	sight_box.polygon[1] = Vector2(sight_range, -sight_height)
	sight_box.polygon[2] = Vector2(sight_range, sight_height)


func on_area_enter(area: Area2D):
	print("entered")
	if area.is_in_group("player"):
		var player = area.get_parent()
		if player not in targets_in_sight:
			print("adding")
			targets_in_sight.append(player)


func on_area_exited(area: Area2D):
	print("exited")
	if area.is_in_group("player"):
		var player = area.get_parent()
		if player in targets_in_sight:
			print("removing")
			targets_in_sight.erase(player)


func ray_check():
	if targets_in_sight.size() <= 0: return

	for target in targets_in_sight:
		if can_see_target(target):
			print("can see")
			emit_signal("spotted_target", target)
		else:
			print("cant see")

	queue_redraw()
			

func can_see_target(target: Player) -> bool:
	var space_state = get_world_2d().direct_space_state

	var start = global_position
	var end = Vector2(target.global_position.x, target.global_position.y - 30)

	var query = PhysicsRayQueryParameters2D.create(start, end)
	query.exclude = [self]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	if result.is_empty():
		return false
	
	return result.collider.get_parent() == target


func _draw():
	if !debug_draw: return
	for target in targets_in_sight:
		draw_line(
			to_local(global_position),
			to_local(Vector2(target.global_position.x, target.global_position.y - 30)),
			Color.RED,
			1.5
		)
