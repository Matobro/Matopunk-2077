extends CharacterBody2D

class_name Enemy

@export_category("Dependencies")
@export var enemy_actions: EnemyActions
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var weapon_component: WeaponComponent

@export_category("Action Settings")
@export var detection_range: float = 200.0
@export var max_combat_range: float = 100.0
@export var min_combat_range: float = 50.0
@export var neutral_action_duration: float = 10.0

@export_category("Wander Settings")
@export var max_wander_distance: float = 50.0
@export var wander_max_duration: float = 2.0
var wander_timer = 0.0


## Input info
var input_x: float
var aim: Vector2
var run_input: bool
var shoot: bool
var crouch_input: bool
var reload_input: bool
var jump_input: bool
var slide_input: bool
var weapon_scroll: int

## State info

var is_grounded: bool
var is_on_platform: bool
var slide_state: bool = false
var moving_forward: bool
var crouch: bool = false
var run: bool


var spawn_position: Vector2
var possible_targets: Array
var current_target: Player
var action_timer: float = 0.0

var decided_action

enum Action {
	Idle,
	Wander,
	Engage
}


func _ready() -> void:
	connect_signals()
	EntityManager.register_enemy(self)
	possible_targets = get_targets()
	spawn_position = global_position
	aim = spawn_position

	
func connect_signals():
	weapon_component.reload_done.connect(enemy_actions.reload_done)
	weapon_component.shot_fired.connect(enemy_actions.shot_fired)


func _physics_process(delta: float) -> void:
	update_state()
	apply_physics(delta)
	handle_decisions(delta)
	handle_movement()
	handle_animation()

	move_and_slide()


func update_state() -> void:
	is_grounded = gravity_component.is_grounded(self)
	is_on_platform = gravity_component.is_on_one_way_platform()
	slide_state = movement_component.get_slide_state()
	moving_forward = animation_component.is_moving_forward(input_x)

	crouch = crouch_input


func apply_physics(delta: float) -> void:
	gravity_component.apply_gravity(self, delta)


func handle_decisions(delta: float):
	if action_timer <= 0:
		decided_action = decide_action()
		action_timer = randf_range(0.1, neutral_action_duration)
		return

	match decided_action:
			Action.Idle:
				idle()
			Action.Wander:
				wander(delta)

	action_timer -= delta


func decide_action():
	if possible_targets.size() <= 0:
		var rng = randi() % 2
		match rng:
			0: return Action.Wander
			1: return Action.Wander

	possible_targets = get_targets()
	var rng = randi() % 2
	match rng:
		0: return Action.Wander
		1: return Action.Wander


func handle_movement() -> void:
	movement_component.handle_horizontal_movement(
		self,
		input_x,
		run,
		moving_forward,
		crouch
	)


func handle_animation() -> void:
	animation_component.handle_orientation(self, aim)
	animation_component.handle_movement_animation(
		self,
		input_x,
		aim,
		run,
		crouch,
		is_grounded,
		slide_state
	)
	animation_component.handle_arms(aim)


func get_targets():
	return EntityManager.get_all_players()


func idle():
	aim = Vector2.ZERO
	input_x = 0


func wander(delta):
	if input_x == 0:
		input_x = randi() % 2
	
	run = false
	var right_edge = spawn_position.x + max_wander_distance
	var left_edge = spawn_position.x - max_wander_distance
	aim = Vector2(global_position.x + (input_x * 50), global_position.y + 10)

	if global_position.x > right_edge:
		wander_turn()
		return
	elif global_position.x < left_edge:
		wander_turn()
		return

	wander_timer += delta

	if wander_timer >= wander_max_duration:
		wander_timer = 0.0
		wander_turn()

func wander_turn():
	print("turning")
	input_x = -input_x