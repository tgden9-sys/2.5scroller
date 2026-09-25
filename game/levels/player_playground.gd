extends Node3D

@onready var player: PlayerController = $Player
@onready var state_label: Label = $UI/Margin/VBox/State
@onready var objective_label: Label = $UI/Margin/VBox/Objective

var _checkpoint_index := -1
var _course_complete := false

const CHECKPOINTS := [
	{"threshold": 3.0, "min_y": -1.0, "spawn": Vector3(4.0, 0.1, 0.0), "message": "CHECKPOINT 1  ·  CLIMB TO THE HIGH PERCH"},
	{"threshold": 45.0, "min_y": 2.0, "spawn": Vector3(46.0, 2.9, 0.0), "message": "CHECKPOINT 2  ·  CLIMB, THEN DIVE TO THE FINISH"},
	{"threshold": 58.0, "min_y": 6.5, "spawn": Vector3(60.0, 7.4, 0.0), "message": "CHECKPOINT 3  ·  DIVE TO THE FOREST FLOOR"},
]

func _ready() -> void:
	player.movement_state_changed.connect(_on_player_state_changed)
	_on_player_state_changed(player.get_movement_state())
	objective_label.text = "STAGE 1  ·  CLEAR THE GAP"

func _process(_delta: float) -> void:
	for index in range(_checkpoint_index + 1, CHECKPOINTS.size()):
		var checkpoint: Dictionary = CHECKPOINTS[index]
		if player.global_position.x >= checkpoint.threshold and player.global_position.y >= checkpoint.min_y:
			_checkpoint_index = index
			player.set_respawn_position(checkpoint.spawn)
			objective_label.text = checkpoint.message
	if not _course_complete and player.global_position.x >= 69.0 and player.is_on_floor():
		_course_complete = true
		objective_label.text = "COURSE COMPLETE  ·  MOVEMENT BASELINE READY"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_R:
		player.reset_to_spawn()

func _on_player_state_changed(state: StringName) -> void:
	state_label.text = "STATE  %s" % state.to_upper()
