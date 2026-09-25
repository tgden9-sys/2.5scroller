extends Node3D

@onready var player: PlayerController = $Player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_R:
		player.reset_to_spawn()
