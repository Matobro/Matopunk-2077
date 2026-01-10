extends CharacterBody2D
class_name Player


@export_category("Dependencies")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var animation_component: AnimationComponent
@export var inventory_component: InventoryComponent
@export var weapon_component: WeaponComponent
@export var camera: PlayerCamera
@export var sound_player: SoundPlayer

@export var gun_data_ui: GunDataUI


func _ready() -> void:
	inventory_component.connect("gained_weapon", gained_weapon)
	inventory_component.connect("gained_ammo", gained_ammo)
	weapon_component.connect("magazine_changed", magazine_changed)
	weapon_component.connect("ammo_changed", ammo_changed)
	weapon_component.connect("weapon_changed", weapon_changed)
	weapon_component.connect("reloading", reloading)
	weapon_component.connect("shot_fired", shot_fired)
	weapon_component.connect("reload_done", reload_done)


func _physics_process(delta: float) -> void:
	var input_x = input_component.input_horizontal
	var aim = input_component.get_aim_position()
	var run_input = input_component.run_input()
	var shoot = input_component.shoot_input()
	var crouch_input = input_component.crouch_input()
	var reload_input = input_component.reload_input()
	var is_grounded = gravity_component.is_grounded(self)
	var is_on_platform = gravity_component.is_on_one_way_platform(self)
	var jump_input = input_component.jump_input()

	animation_component.handle_orientation(self, aim)

	var moving_forward = animation_component.is_moving_forward(input_x)
	var crouch = crouch_input
	var run = run_input and moving_forward and !crouch

	gravity_component.apply_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_x, run, moving_forward, crouch)

	animation_component.handle_movement_animation(self, input_x, aim, run, crouch)
	animation_component.handle_arms(aim)

	if shoot:
		weapon_component.try_shoot()

	if reload_input:
		weapon_component.reload()

	if is_grounded and jump_input:
		movement_component.jump(self)
	
	if is_on_platform and crouch_input:
		print("dropping down")
		movement_component.drop_down(self)


	move_and_slide()


func gained_weapon(weapon_data: WeaponData):
	if inventory_component.get_weapons_amount() <= 1:
		gun_data_ui.show_gun_data(true)
		weapon_component.swap_weapon(weapon_data)
		pass


func gained_ammo(weapon: WeaponData):
	ammo_changed(weapon.get_ammo())


func weapon_changed(weapon: Weapon):
	gun_data_ui.update_gun_icon(weapon.weapon_data.weapon_icon)


func ammo_changed(ammo: int):
	gun_data_ui.update_ammo_data(ammo)


func magazine_changed(magazine: int):
	gun_data_ui.update_magazine_data(magazine)


func reloading(total_duration):
	gun_data_ui.update_reload_bar(total_duration)


func shot_fired(data: WeaponData):
	sound_player.play_audio(data.shoot)
	camera.apply_camera_shake(data.kick_strength, data.kick_fade_speed)


func reload_done(data: WeaponData):
	sound_player.play_audio(data.reload)
