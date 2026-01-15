extends CharacterBody2D
class_name Player


@export_category("Dependencies")
@export var player_actions: PlayerActions
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var animation_component: AnimationComponent
@export var inventory_component: InventoryComponent
@export var weapon_component: WeaponComponent
@export var stat_component: StatComponent
@export var hit_component: HitComponent
@export var trigger_component: TriggerHitComponent

@export var health_ui: HealthUI
@export var gun_data_ui: GunDataUI

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
var slide_state: bool
var moving_forward: bool
var crouch: bool
var run: bool
var can_enter_stairs: bool
var on_stairs: bool

var default_mask
var stair_exit_timer: float = 0.0

const STAIR_EXIT_DELAY: float = 0.2

func _ready() -> void:
	connect_signals()
	EntityManager.register_player(self)
	default_mask = collision_mask


func _physics_process(delta: float) -> void:
	read_inputs()
	apply_physics(delta)
	handle_movement()
	handle_weapons()
	handle_animation()
	move_and_slide()
	update_state(delta)


func connect_signals():
	inventory_component.gained_ammo.connect(
		func(weapon):
			player_actions.gained_ammo(weapon, weapon_component.current_weapon)
	)

	weapon_component.weapon_changed.connect(player_actions.weapon_changed)
	weapon_component.magazine_changed.connect(player_actions.magazine_changed)
	weapon_component.ammo_changed.connect(player_actions.ammo_changed)
	weapon_component.reloading.connect(player_actions.reloading)
	weapon_component.reload_progress.connect(player_actions.reload_progress)
	weapon_component.reload_done.connect(player_actions.reload_done)
	weapon_component.shot_fired.connect(player_actions.shot_fired)
	stat_component.current_health_changed.connect(player_actions.on_current_health_changed)
	stat_component.max_health_changed.connect(player_actions.on_max_health_changed)

	inventory_component.connect("gained_weapon", gained_weapon)

	hit_component.connect("bullet_hit", on_bullet_hit)

	movement_component.slide_started.connect(on_slide_start)
	movement_component.slide_ended.connect(on_slide_end)

	trigger_component.stairs_entered.connect(on_stairs_entered)
	trigger_component.stairs_exited.connect(on_stairs_exited)

func read_inputs() -> void:
	input_x = input_component.input_horizontal
	aim = input_component.get_aim_position()
	run_input = true # input_component.run_input()
	shoot = input_component.shoot_input()
	crouch_input = input_component.crouch_input()
	reload_input = input_component.reload_input()
	jump_input = input_component.jump_input()
	slide_input = input_component.slide_input()
	weapon_scroll = input_component.weapon_scroll_input()


func update_state(delta: float) -> void:
	is_grounded = gravity_component.is_grounded(self)
	is_on_platform = gravity_component.is_on_one_way_platform()
	slide_state = movement_component.get_slide_state()
	moving_forward = animation_component.is_moving_forward(input_x)

	crouch = crouch_input
	run = run_input and !crouch

	if stair_exit_timer > 0:
		stair_exit_timer -= delta

	# Exit stairs if leaving or crouching
	if on_stairs and (crouch_input or !can_enter_stairs):
		set_stairs_collider(false)
		stair_exit_timer = STAIR_EXIT_DELAY

	# Enter stairs via input
	if can_enter_stairs and input_component.up_input():
		set_stairs_collider(true)

	# Enter stairs if falling on em
	if velocity.y > 0 and !on_stairs and stair_exit_timer <= 0:
		set_stairs_collider(true)


func apply_physics(delta: float) -> void:
	gravity_component.apply_gravity(self, delta)


func set_stairs_collider(value: bool):
	if value:
		print("entering")
		collision_mask = default_mask | (1 << 9)
	else:
		print("exiting")
		collision_mask = default_mask

	on_stairs = value


func handle_movement() -> void:
	if !slide_state:
		movement_component.handle_horizontal_movement(
			self,
			input_x,
			run,
			moving_forward,
			crouch
		)

	if !slide_state and slide_input and run:
		movement_component.start_slide(self, input_x)

	if is_grounded and jump_input:
		movement_component.jump(self)

	if is_on_platform and crouch_input:
		movement_component.drop_down(self)


func handle_weapons() -> void:
	if weapon_scroll != 0 and inventory_component.get_weapons_amount() > 1:
		change_weapon(weapon_scroll)
		return

	if shoot:
		weapon_component.try_shoot(hit_component, self)

	if reload_input:
		weapon_component.reload()


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


func change_weapon(index_direction: int):
	if index_direction == 0: return
	
	## 0 weapon data, 1 index of weapon in inventory
	var request

	if index_direction == 1:
		request = inventory_component.get_next_weapon()
	
	if index_direction == 2:
		request = inventory_component.get_previous_weapon()

	if request[0] != null:
		weapon_component.swap_weapon(request[0], false)
		inventory_component.commit_equip(request[1])


func gained_weapon(weapon_data: WeaponData):
	if inventory_component.get_weapons_amount() <= 1:
		gun_data_ui.show_gun_data(true)
		weapon_component.swap_weapon(weapon_data, false)
		inventory_component.commit_equip(0)
		pass


func on_bullet_hit(damage):
	stat_component.take_damage(damage)


func on_slide_start():
	hit_component.set_collision_enabled(false)


func on_slide_end():
	hit_component.set_collision_enabled(true)


func on_stairs_entered():
	can_enter_stairs = true


func on_stairs_exited():
	can_enter_stairs = false
