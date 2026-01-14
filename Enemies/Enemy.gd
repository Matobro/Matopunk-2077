extends CharacterBody2D

class_name Enemy

@export_category("Dependencies")
@export var enemy_actions: EnemyActions
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var weapon_component: WeaponComponent
@export var hit_component: HitComponent
@export var stat_component: StatComponent
@export var ai_component: EnemyAI
@export var sight_component: SightComponent

@export_category("Enemy Settings")
@export var weapon: WeaponData

## Input info
var movement_direction: int
var aim: Vector2

## State info
var is_grounded: bool
var is_on_platform: bool
var slide_state: bool = false
var moving_forward: bool
var crouch: bool = false
var run: bool


func _ready() -> void:
	connect_signals()
	ai_component.initialize_ai(self)
	EntityManager.register_enemy(self)
	equip_weapon()

	
func connect_signals():
	weapon_component.reload_done.connect(enemy_actions.reload_done)
	weapon_component.shot_fired.connect(enemy_actions.shot_fired)
	hit_component.bullet_hit.connect(on_bullet_hit)
	ai_component.set_movement_direction.connect(set_movement_direction)
	ai_component.set_aim_position.connect(set_aim_position)
	sight_component.spotted_target.connect(on_target_spotted)
	ai_component.call_shoot.connect(call_shoot)
	ai_component.set_run.connect(set_run)
	weapon_component.unlimited_ammo = true


func _physics_process(delta: float) -> void:
	ai_component.run_ai(delta, self)
	update_state()
	apply_physics(delta)
	handle_movement()
	handle_animation()

	move_and_slide()


func update_state() -> void:
	is_grounded = gravity_component.is_grounded(self)
	is_on_platform = gravity_component.is_on_one_way_platform()
	slide_state = movement_component.get_slide_state()
	moving_forward = animation_component.is_moving_forward(movement_direction)


func apply_physics(delta: float) -> void:
	gravity_component.apply_gravity(self, delta)


func handle_movement() -> void:
	movement_component.handle_horizontal_movement(
		self,
		movement_direction,
		run,
		moving_forward,
		crouch
	)


func handle_animation() -> void:
	animation_component.handle_orientation(self, aim)
	animation_component.handle_movement_animation(
		self,
		movement_direction,
		aim,
		run,
		crouch,
		is_grounded,
		slide_state
	)
	animation_component.handle_arms(aim)


func equip_weapon():
	weapon_component.swap_weapon(weapon, true)


func set_movement_direction(dir):
	movement_direction = dir


func set_aim_position(pos: Vector2):
	aim = pos


func on_bullet_hit(damage):
	stat_component.take_damage(damage)


func on_target_spotted(player: Player):
	ai_component.target_spotted(player)


func call_shoot():
	weapon_component.try_shoot()


func set_run(value):
	run = value
