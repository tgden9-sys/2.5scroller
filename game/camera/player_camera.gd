class_name PlayerCamera
extends Camera3D

@export var target: Node3D
@export var follow_speed := 5.5
@export var look_ahead_distance := 2.2
@export var vertical_dead_zone := 1.0
@export var min_height := 3.5
@export var min_x := -INF
@export var max_x := INF

var _base_z: float

func _ready() -> void:
	_base_z = global_position.z

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	var target_body := target as CharacterBody3D
	var direction := signf(target_body.velocity.x) if target_body else 0.0
	var desired := global_position
	desired.x = target.global_position.x + direction * look_ahead_distance
	var vertical_error := target.global_position.y - global_position.y
	if absf(vertical_error) > vertical_dead_zone:
		desired.y += vertical_error - signf(vertical_error) * vertical_dead_zone
	desired.y = maxf(desired.y, min_height)
	desired.x = clampf(desired.x, min_x, max_x)
	desired.z = _base_z
	global_position = global_position.lerp(desired, 1.0 - exp(-follow_speed * delta))
