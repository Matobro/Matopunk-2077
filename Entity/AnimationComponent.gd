extends Node
class_name AnimationComponent


@export var animation_player: AnimationPlayer
@export var arm_left: Node2D
@export var arm_right: Node2D

@export_category("Animations")
@export var walk_forward: String = "walk_forward"
@export var walk_backward: String = "walk_backward"
@export var idle: String = "idle"
@export var run_forward: String = "run_forward"
@export var crouch_forward: String = "crouch_walk_forward"
@export var crouch_backward: String = "crouch_walk_backward"
@export var crouch_idle: String = "crouch_idle"

@export_category("Animation speeds")
@export var walk_forward_speed: float = 0.8
@export var walk_backward_speed: float = 0.5
@export var idle_speed: float = 0.8
@export var run_forward_speed: float = 0.8
@export var crouch_forward_speed: float = 0.8
@export var crouch_backward_speed: float = 0.5
@export var crouch_idle_speed: float = 0.8


var is_facing_right: bool = true


func handle_orientation(body: CharacterBody2D, look_target: Vector2):
    var distance_to_look_target = look_target.x - body.global_position.x

    if distance_to_look_target > 0 and !is_facing_right:
        body.scale.x *= -1
        is_facing_right = true

    elif distance_to_look_target < 0 and is_facing_right:
        body.scale.x *= -1
        is_facing_right = false

func handle_movement_animation(body: CharacterBody2D, move_direction: float, look_target: Vector2, is_run: bool, is_crouch: bool, is_grounded: bool):
    handle_orientation(body, look_target)

    ## Insert jump animation here
    if !is_grounded:
        animation_player.play(idle)
        animation_player.speed_scale = idle_speed
        return

    #############################
    
    if move_direction == 0:
        if is_crouch:
            animation_player.play(crouch_idle)
            animation_player.speed_scale = crouch_idle_speed
        else:
            animation_player.play(idle)
            animation_player.speed_scale = idle_speed
        return

    var moving_forward = is_moving_forward(move_direction)

    if moving_forward:
        if is_crouch:
            animation_player.play(crouch_forward)
            animation_player.speed_scale = crouch_forward_speed
        elif is_run:
            animation_player.play(run_forward)
            animation_player.speed_scale = walk_forward_speed
        else:
            animation_player.play(walk_forward)
            animation_player.speed_scale = walk_forward_speed
    else:
        if is_crouch:
            animation_player.play(crouch_backward)
            animation_player.speed_scale = crouch_backward_speed
        else:
            animation_player.play(walk_backward)
            animation_player.speed_scale = walk_backward_speed


func handle_arms(look_target: Vector2):
    arm_left.look_at(look_target)
    arm_right.look_at(look_target)

func is_moving_forward(move_direction: float) -> bool:
    if move_direction == 0:
        return false
    
    var moving_right = move_direction > 0
    return moving_right == is_facing_right