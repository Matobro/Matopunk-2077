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


func _ready() -> void:
	connect_signals()
	EntityManager.register_player(self)


func _physics_process(delta: float) -> void:
	read_inputs()
	update_state()
	apply_physics(delta)
	handle_movement()
	handle_weapons()
	handle_animation()
	move_and_slide()


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

	inventory_component.connect("gained_weapon", gained_weapon)


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


func update_state() -> void:
	is_grounded = gravity_component.is_grounded(self)
	is_on_platform = gravity_component.is_on_one_way_platform()
	slide_state = movement_component.get_slide_state()
	moving_forward = animation_component.is_moving_forward(input_x)

	crouch = crouch_input
	run = run_input and !crouch


func apply_physics(delta: float) -> void:
	gravity_component.apply_gravity(self, delta)


func handle_movement() -> void:
	if !slide_state:
		movement_component.handle_horizontal_movement(
			self,
			input_x,
			run,
			moving_forward,
			crouch
		)

	if !slide_state and is_grounded and slide_input and run:
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
		weapon_component.try_shoot()

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


## Weapon managing ##


func change_weapon(index_direction: int):
	if index_direction == 0: return
	
	## 0 weapon data, 1 index of weapon in inventory
	var request

	if index_direction == 1:
		request = inventory_component.get_next_weapon()
	
	if index_direction == 2:
		request = inventory_component.get_previous_weapon()

	if request[0] != null:
		weapon_component.swap_weapon(request[0])
		inventory_component.commit_equip(request[1])


func gained_weapon(weapon_data: WeaponData):
	if inventory_component.get_weapons_amount() <= 1:
		gun_data_ui.show_gun_data(true)
		weapon_component.swap_weapon(weapon_data)
		inventory_component.commit_equip(0)
		pass
