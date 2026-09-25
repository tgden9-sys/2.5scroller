class_name PlayerVisual
extends Node3D

@export var pose_blend_speed := 10.0
@export var landing_squash_amount := 0.18
@export var landing_recovery_speed := 8.0

@onready var controller: PlayerController = get_parent()
@onready var hero_sprite: Sprite3D = $HeroSprite
@onready var flight_sprite: Sprite3D = $FlightSprite

var _state: StringName = &"idle"
var _time := 0.0
var _landing_squash := 0.0
var _previous_airborne := false
var _facing_direction := 1.0

func _ready() -> void:
	controller.movement_state_changed.connect(_on_movement_state_changed)
	_state = controller.get_movement_state()

func _process(delta: float) -> void:
	_time += delta
	var airborne := not controller.is_on_floor()
	if _previous_airborne and not airborne:
		_landing_squash = landing_squash_amount
	_previous_airborne = airborne
	_landing_squash = move_toward(_landing_squash, 0.0, landing_recovery_speed * delta)
	if absf(controller.velocity.x) > 0.1:
		_facing_direction = signf(controller.velocity.x)

	var target_rotation := _target_body_rotation()
	rotation.z = lerp_angle(rotation.z, target_rotation, _blend_weight(delta))
	hero_sprite.flip_h = _facing_direction < 0.0
	flight_sprite.flip_h = _facing_direction < 0.0
	var show_flight := _state in [&"rise", &"fall", &"glide", &"dive"]
	hero_sprite.visible = not show_flight
	flight_sprite.visible = show_flight
	_update_body_motion()

func _target_body_rotation() -> float:
	match _state:
		&"run":
			return -signf(controller.velocity.x) * 0.1
		&"rise":
			return -signf(controller.velocity.x) * 0.16
		&"fall":
			return signf(controller.velocity.x) * 0.08
		&"glide":
			return -signf(controller.velocity.x) * 0.05
		&"dive":
			return signf(controller.velocity.x if not is_zero_approx(controller.velocity.x) else 1.0) * 0.32
		_:
			return 0.0

func _update_body_motion() -> void:
	var idle_bob := sin(_time * 2.4) * 0.025 if _state == &"idle" else 0.0
	var run_bob := absf(sin(_time * 9.0)) * 0.045 if _state == &"run" else 0.0
	position.y = idle_bob - _landing_squash * 0.45
	position.y += run_bob
	var pose_stretch := 1.06 if _state == &"glide" else 1.0
	var pose_squash := 0.92 if _state == &"dive" else 1.0
	var stretch := pose_stretch + _landing_squash
	var squash := pose_squash - _landing_squash
	scale = Vector3(stretch, squash, stretch)

func _blend_weight(delta: float) -> float:
	return 1.0 - exp(-pose_blend_speed * delta)

func _on_movement_state_changed(next_state: StringName) -> void:
	_state = next_state
