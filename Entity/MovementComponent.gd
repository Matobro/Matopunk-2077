extends Node
class_name MovementComponent


@export_category("Run/Walk Settings")
@export var speed: float = 100
@export var run_speed: float = 150
@export var backward_walk_multiplier: float = 0.8
@export var walk_multiplier: float = 1.0
@export var run_multiplier: float = 1.5
@export var backward_run_multiplier: float = 0.5
@export var crouch_walk_multiplier: float = 0.6
@export var backward_crouch_multiplier: float = 0.3

@export_category("Jump Settings")
@export var jump_force: float = 100.0


func handle_horizontal_movement(body: CharacterBody2D, direction: float, run: bool, moving_forward: bool, crouch: bool):
    var multiplier = 1

    if crouch:
        multiplier = crouch_walk_multiplier if moving_forward else backward_crouch_multiplier
    elif run:
        multiplier = run_multiplier if moving_forward else backward_run_multiplier
    else:
        multiplier = walk_multiplier if moving_forward else backward_walk_multiplier

    body.velocity.x = direction * speed * multiplier


func jump(body: CharacterBody2D):
    body.velocity.y -= jump_force


func drop_down(body: CharacterBody2D):
    body.position.y += 1