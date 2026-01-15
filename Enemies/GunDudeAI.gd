extends EnemyAI

class_name GunDudeAI

@export_category("AI Settings")
@export var base_action_duration: float = 5.0
@export var action_duration_variation: float = 2.0
var action_duration: float = 0.0
var action_timer: float = 0.0

@export_category("Idle Settings")

@export_category("Wander Settings")
@export var max_move_distance: float = 50.0
@export var wander_aim_y_position: float = 25.0

@export_category("Engage Settings")
@export var max_range: float = 200.0
@export var min_range: float = 100.0
@export var shoot_range: float = 150.0

@export_category("Aim Settings")
@export var aim_variance: float = 0.0
@export var reaim_time: float = 0.5
var aim_timer: float = 0.0

@export_category("Decision Settings")
@export var chances = {
    Action.IDLE: 7,
    Action.WANDER: 3
}

var original_position: Vector2
var current_action: Action
var target: Player

enum Action {
    IDLE,
    WANDER,
    ENGAGE
}


func initialize_ai(enemy: Enemy):
    action_duration = get_action_duration()
    original_position = enemy.global_position


func run_ai(delta: float, enemy: Enemy):
    if current_action != Action.ENGAGE:
        action_timer += delta
        if action_timer > action_duration:
            action_timer = 0.0
            action_duration = get_action_duration()
            current_action = decide_action(enemy)
            emit_signal("set_run", false)

        match current_action:
            Action.IDLE:
                idle(enemy)
            Action.WANDER:
                wander(enemy)

    if current_action == Action.ENGAGE:
        aim_timer += delta
        if aim_timer > reaim_time:
            aim_timer = 0.0
            var aim = Vector2(target.global_position.x, (target.global_position.y - 24) + randf_range(-aim_variance, aim_variance))

            emit_signal("set_aim_position", aim)

        engage()

        if global_position.distance_to(target.global_position) <= shoot_range:
            emit_signal("call_shoot")


func target_spotted(player: Player):
    target = player
    current_action = Action.ENGAGE

    var aim = Vector2(target.global_position.x, (target.global_position.y - 24) + randf_range(-aim_variance, aim_variance))

    emit_signal("set_aim_position", aim)


func engage():
    if target == null:
        current_action = Action.IDLE
        return

    var dist = global_position.distance_to(target.global_position)
    var player_side = -1 if global_position.x > target.global_position.x else 1

    if dist >= max_range and dist >= shoot_range:
        emit_signal("set_run", true)
        emit_signal("set_movement_direction", player_side)
    elif dist >= max_range and dist <= shoot_range:
        emit_signal("set_run", false)
        emit_signal("set_movement_direction", player_side)
    elif dist <= min_range:
        emit_signal("set_run", true)
        emit_signal("set_movement_direction", -player_side)
    else:
        emit_signal("set_run", false)
        emit_signal("set_movement_direction", 0)


func decide_action(enemy: Enemy) -> Action:
    var total: int = 0
    for weight in chances.values():
        total += weight

    var roll: int = randi_range(0, total - 1)
    var running: int = 0

    for action in chances.keys():
        running += chances[action]
        if roll < running:
            if action == Action.WANDER:
                var movement_direction = -1 if randi() % 2 == 0 else 1
                emit_signal("set_movement_direction", movement_direction)

                if movement_direction == -1:
                    emit_signal("set_aim_position", Vector2(enemy.position.x - (max_move_distance * 10), enemy.position.y + wander_aim_y_position))
                else:
                    emit_signal("set_aim_position", Vector2(enemy.position.x + (max_move_distance * 10), enemy.position.y + wander_aim_y_position))

            if action == Action.IDLE:
                var look_dir = randi() % 2
                
                if look_dir == 0:
                    emit_signal("set_aim_position", Vector2(enemy.position.x + 10, enemy.position.y + 100)) ## left
                else:
                    emit_signal("set_aim_position", Vector2(enemy.position.x - 10, enemy.position.y + 100)) ## right
            return action

    return Action.IDLE # fallback


func wander(enemy: Enemy):
    var left_edge = original_position.x - max_move_distance
    var right_edge = original_position.x + max_move_distance

    if enemy.global_position.x > right_edge:
        emit_signal("set_movement_direction", -1) ## left
        emit_signal("set_aim_position", Vector2(enemy.position.x - (max_move_distance * 10), enemy.position.y + wander_aim_y_position))
        return

    elif enemy.global_position.x < left_edge:
        emit_signal("set_movement_direction", 1) ## right
        emit_signal("set_aim_position", Vector2(enemy.position.x + (max_move_distance * 10), enemy.position.y + wander_aim_y_position))
        return
        

func idle(enemy: Enemy):
    emit_signal("set_movement_direction", 0)


func get_action_duration() -> float:
    return base_action_duration + randf_range(-action_duration, action_duration)