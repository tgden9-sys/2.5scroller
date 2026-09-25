class_name PlayerController
extends CharacterBody3D

signal movement_state_changed(state: StringName)

@export_category("Ground movement")
@export var max_run_speed := 8.5
@export var ground_acceleration := 52.0
@export var ground_deceleration := 68.0

@export_category("Air movement")
@export var air_acceleration := 24.0
@export var air_deceleration := 12.0
@export var air_speed_multiplier := 0.9
@export var fall_gravity_multiplier := 1.65

@export_category("Jump")
@export var jump_velocity := 12.0
@export var jump_cut_multiplier := 0.45
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.14

@export_category("Wing prototypes")
@export var flap_velocity := 8.5
@export var flap_horizontal_boost := 1.5
@export var glide_fall_speed := 2.4
@export var glide_gravity_multiplier := 0.18
@export var dive_gravity_multiplier := 4.0
@export var dive_max_speed := 28.0

@export_category("Safety")
@export var fall_reset_y := -18.0

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _flap_available := true
var _spawn_position: Vector3
var _state: StringName = &"idle"

func _ready() -> void:
	_spawn_position = global_position

func _physics_process(delta: float) -> void:
	var was_on_floor := is_on_floor()
	_update_timers(delta, was_on_floor)
	_read_jump_input()
	_apply_horizontal_movement(delta)
	_apply_vertical_movement(delta, was_on_floor)
	move_and_slide()
	lock_to_gameplay_plane()
	_update_state()
	if global_position.y < fall_reset_y:
		reset_to_spawn()

func _update_timers(delta: float, grounded: bool) -> void:
	if grounded:
		_coyote_timer = coyote_time
		_flap_available = true
	else:
		_coyote_timer = maxf(_coyote_timer - delta, 0.0)
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)

func _read_jump_input() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	if Input.is_action_just_released("jump"):
		if velocity.y > 0.0:
			velocity.y *= jump_cut_multiplier

func _apply_horizontal_movement(delta: float) -> void:
	var input_axis := Input.get_axis("move_left", "move_right")
	var grounded := is_on_floor()
	var top_speed := max_run_speed if grounded else max_run_speed * air_speed_multiplier
	var target_speed := input_axis * top_speed
	var rate := ground_acceleration if grounded else air_acceleration
	if is_zero_approx(input_axis):
		rate = ground_deceleration if grounded else air_deceleration
	velocity.x = move_toward(velocity.x, target_speed, rate * delta)

func _apply_vertical_movement(delta: float, was_on_floor: bool) -> void:
	var can_ground_jump := was_on_floor or _coyote_timer > 0.0
	if _jump_buffer_timer > 0.0 and can_ground_jump:
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0
		return

	if _jump_buffer_timer > 0.0 and not can_ground_jump and _flap_available:
		velocity.y = maxf(velocity.y, flap_velocity)
		if not is_zero_approx(velocity.x):
			velocity.x += signf(velocity.x) * flap_horizontal_boost
		_flap_available = false
		_jump_buffer_timer = 0.0
		return

	if not was_on_floor:
		if Input.is_action_pressed("move_down"):
			velocity.y = maxf(velocity.y - _gravity * dive_gravity_multiplier * delta, -dive_max_speed)
		elif Input.is_action_pressed("jump") and velocity.y <= 0.0 and not _flap_available:
			velocity.y = maxf(velocity.y - _gravity * glide_gravity_multiplier * delta, -glide_fall_speed)
		else:
			var gravity_multiplier := fall_gravity_multiplier if velocity.y <= 0.0 else 1.0
			velocity.y -= _gravity * gravity_multiplier * delta

func lock_to_gameplay_plane() -> void:
	global_position.z = 0.0
	velocity.z = 0.0

func reset_to_spawn() -> void:
	global_position = _spawn_position
	velocity = Vector3.ZERO
	_jump_buffer_timer = 0.0
	_coyote_timer = 0.0
	_flap_available = true

func set_respawn_position(position: Vector3) -> void:
	_spawn_position = position

func _update_state() -> void:
	var next_state: StringName
	if is_on_floor():
		next_state = &"run" if absf(velocity.x) > 0.25 else &"idle"
	elif Input.is_action_pressed("move_down"):
		next_state = &"dive"
	elif Input.is_action_pressed("jump") and velocity.y <= 0.0 and not _flap_available:
		next_state = &"glide"
	elif velocity.y > 0.0:
		next_state = &"rise"
	else:
		next_state = &"fall"
	if next_state != _state:
		_state = next_state
		movement_state_changed.emit(_state)

func get_movement_state() -> StringName:
	return _state
