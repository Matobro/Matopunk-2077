extends Node
class_name MovementComponent


@export_category("Run/Walk Settings")
@export var speed: float = 100
@export var backward_walk_multiplier: float = 0.8
@export var walk_multiplier: float = 1.0
@export var run_multiplier: float = 1.5
@export var backward_run_multiplier: float = 0.5
@export var crouch_walk_multiplier: float = 0.6
@export var backward_crouch_multiplier: float = 0.3

@export_category("Jump Settings")
@export var jump_force: float = 100.0

@export_category("Slide Settings")
@export var slide_force: float = 250.0
@export var slide_duration: float = 10.0

var is_sliding: bool = false
var slide_timer: float = 0.0

signal slide_started()
signal slide_ended()

func handle_horizontal_movement(body: CharacterBody2D, direction: float, run: bool, moving_forward: bool, crouch: bool):
	var multiplier = 1

	if crouch:
		multiplier = crouch_walk_multiplier if moving_forward else backward_crouch_multiplier
	elif run:
		multiplier = run_multiplier if moving_forward else backward_run_multiplier
	else:
		multiplier = walk_multiplier if moving_forward else backward_walk_multiplier

	body.velocity.x = direction * speed * multiplier


func _process(delta):
	if is_sliding and slide_timer > 0:
		slide_timer -= delta

	if is_sliding and slide_timer <= 0:
		is_sliding = false
		end_slide()

func jump(body: CharacterBody2D):
	body.velocity.y = -jump_force


func drop_down(body: CharacterBody2D):
	body.position.y += 1


func slide(body: CharacterBody2D, direction: float):
	body.velocity.x = direction * slide_force


func start_slide(body: CharacterBody2D, direction: float):
	if is_sliding: return
	is_sliding = true

	slide_timer = slide_duration
	slide(body, direction)

	emit_signal("slide_started")


func end_slide():
	is_sliding = false
	emit_signal("slide_ended")


func get_slide_state() -> bool:
	return is_sliding
