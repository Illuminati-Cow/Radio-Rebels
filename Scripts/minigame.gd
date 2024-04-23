class_name IMiniGame extends Node2D

signal minigame_over(scores)

@export_group("UI Scenes")
@export var controls_screen : PackedScene
@export var controls_screen_accept_action : String = "ui_accept"
@export var pause_screen : PackedScene

var _player_count : int


# Set up the game for the number of players specified
func setup(player_count : int) -> void:
	_player_count = player_count


# Start the game's sequence
func start() -> void:
	await show_controls()


func pause() -> void:
	pass


# Coroutine - Shows the controls screen and then closes it after user input
func show_controls() -> bool:
	var screen := controls_screen.instantiate()
	add_child(screen)
	await input_awaiter(controls_screen_accept_action)
	return true


# Coroutine - Wait for the specified input and then return true
func input_awaiter(action : String) -> bool:
	var action_fired := false
	while not action_fired:
		if Input.is_action_pressed(action):
			action_fired = true
		else:
			await get_tree().process_frame
	return true
