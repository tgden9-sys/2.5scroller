extends Node3D

@onready var player: PlayerController = $Player
@onready var state_label: Label = $UI/Margin/VBox/State

func _ready() -> void:
	player.movement_state_changed.connect(_on_player_state_changed)
	_on_player_state_changed(player.get_movement_state())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_R:
		player.reset_to_spawn()

func _on_player_state_changed(state: StringName) -> void:
	state_label.text = "STATE  %s" % state.to_upper()
