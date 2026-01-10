extends Node2D

@export_category("Dependencies")
@export var ship_scene: PackedScene

@export_category("Spawner settings")
@export var ship_count: int = 8
@export var horizontal_range: float = 300.0
@export var vertical_range: float = 300.0
@export var loop_margin: float = 100
@export var vertical_offset: float = 0

@export_category("Ship Customization")
@export var ship_variances: Array[Texture2D]
@export var ship_color: Color
@export var use_color: bool = true
@export var ship_min_speed: float = 1.0
@export var ship_max_speed: float = 5.0
@export var ship_min_size: float = 0.8
@export var ship_max_size: float = 1.2
@export var use_debug_color: bool = false

var debug_speed: float = 500.0
var debug_color: Color = Color.GREEN
var debug_layer: int = 1000
var cam: Camera2D
var viewport_size: Vector2
var parallax: Parallax2D

var ships: Array[BackGroundShip]

func _ready():
	cam = get_viewport().get_camera_2d()
	viewport_size = get_viewport_rect().size
	parallax = get_parent()

	randomize()
	_spawn_ships()


func _process(_delta):
	if cam == null:
		return

	for ship in ships:
		loop_ship(ship)


## Instantiate ships (done on scene start)
func _spawn_ships():
	for i in ship_count:
		var ship = ship_scene.instantiate()
		add_child(ship)
		ships.append(ship)
		_recycle_ship(ship)


## Randomize move direction (left-right, right-left) and randomize starting postiion
func _set_ship_position(ship):
	match _randomize_movement_direction():
		# Left-right
		0:	
			ship.global_position.x = (_get_bounds("left") - (loop_margin / 2)) - _randomize_position(horizontal_range)
			ship.set_movement_direction(0)
		# Right-left
		1:
			ship.global_position.x = (_get_bounds("right") + (loop_margin / 2)) + _randomize_position(horizontal_range)
			ship.set_movement_direction(1)

	ship.position.y = _randomize_position(vertical_range) + vertical_offset
	ship.spawn_position = ship.position.x


## Returns 0 for left-right, 1 for right-left
func _randomize_movement_direction() -> int:
	return randi() % 2


## Returns value from 0 to given value
func _randomize_position(float_range) -> float:
	return randf_range(0, float_range)


## Returns world position for left/right side of the screen : "left" for left, otherwise right
func _get_bounds(value: String) -> float:
	var screen = Rect2(cam.global_position - viewport_size / 2, viewport_size)
	var left = screen.position.x
	var right = screen.position.x + screen.size.x

	if value == "left":
		return left
	else:
		return right


## Check if reached screen edge + margin
func loop_ship(ship):
	var loop_position_left = (_get_bounds("left") - loop_margin) - horizontal_range
	var loop_position_right = (_get_bounds("right") + loop_margin) + horizontal_range

	if ship.global_position.x > loop_position_right:
		_recycle_ship(ship)
	elif ship.global_position.x < loop_position_left:
		_recycle_ship(ship)


## Resets ship (essentially spawns a new one)
func _recycle_ship(ship: Node2D):
	var color = ship_color if !use_debug_color else debug_color
	var min_speed = ship_min_speed if !use_debug_color else debug_speed
	var max_speed = ship_max_speed if !use_debug_color else debug_speed

	if use_debug_color:
		ship.set_layer(debug_layer)

	ship.set_color(color, use_color)
	ship.randomize_appearance(ship_variances)
	ship.randomize_speed(min_speed, max_speed)
	ship.randomize_size(ship_min_size, ship_max_size)
	_set_ship_position(ship)
