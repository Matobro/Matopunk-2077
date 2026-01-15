extends Node2D
class_name InputComponent


@export_category("User Settings")
@export var aim_speed: float = 400.0
@export var deadzone: float = 0.2

@export_category("Dependencies")
@export var crosshair: Node2D

enum InputType { MOUSE, CONTROLLER }
enum WeaponScroll { NONE, NEXT, PREV }

var input_type = InputType.MOUSE
var input_horizontal: float = 0.0

var cursor_position: Vector2
var cursor_speed: float = 800.0

var last_slide_press_time: float = 0.0
const DOUBLE_PRESS_TIME: float = 0.25

func _ready() -> void:
	cursor_position = get_viewport().get_visible_rect().size / 2
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	
func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left", "move_right")
	
	if input_type == InputType.CONTROLLER:
		var stick_input = Vector2(
			Input.get_axis("aim_left", "aim_right"),
			Input.get_axis("aim_up", "aim_down")
		)

		if stick_input.length() < deadzone:
			stick_input = Vector2.ZERO
		
		cursor_position += stick_input.normalized() * aim_speed * delta

		var camera := get_viewport().get_camera_2d()
		var screen_size := get_viewport().get_visible_rect().size
		var top_left := camera.global_position - screen_size * 0.5
		var bottom_right := camera.global_position + screen_size * 0.5

		cursor_position.x = clamp(cursor_position.x, top_left.x, bottom_right.x)
		cursor_position.y = clamp(cursor_position.y, top_left.y, bottom_right.y)
		
	crosshair.global_position = get_aim_position()


# Returns where player is aiming. For contollers it uses 'virtual' cursor, for mouse it uses mouse position
func get_aim_position() -> Vector2:
	var base_pos: Vector2 

	if input_type == InputType.MOUSE:
		base_pos = get_global_mouse_position()

	else:
		base_pos = cursor_position

	return base_pos


func crouch_input() -> bool:
	return Input.is_action_pressed("crouch")

	
func shoot_input() -> bool:
	return Input.is_action_pressed("shoot")


func run_input() -> bool:
	return Input.is_action_pressed("run")

	
func jump_input() -> bool:
	return Input.is_action_pressed("jump")


func reload_input() -> bool:
	return Input.is_action_pressed("reload")


func slide_input() -> bool:
	if !Input.is_action_just_pressed("slide"):
		return false
	
	var time_stamp = Time.get_ticks_msec() / 1000.0

	if time_stamp - last_slide_press_time <= DOUBLE_PRESS_TIME:
		last_slide_press_time = 0.0
		print("sliding")
		return true

	last_slide_press_time = time_stamp
	return false


func up_input() -> bool:
	return Input.is_action_pressed("up")
	

## 1 for scroll up, 2 for scroll down, 0 for no input
func weapon_scroll_input() -> int:
	if Input.is_action_just_pressed("weapon_up"):
		return WeaponScroll.NEXT
	
	if Input.is_action_just_pressed("weapon_down"):
		return WeaponScroll.PREV

	return 0