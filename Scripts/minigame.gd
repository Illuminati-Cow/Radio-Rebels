class_name IMinigame extends Node
## Base class that minigames should extend.
##
## This class contains all of the neccesary functions and logic to interface
## with the Game Manager and for common functions of minigames. If overwriting
## a parent function ensure that you are not breaking funcitonality and if in
## doubt, you should call the parent method before executing your logic.

signal minigame_over(scores)

@export_group("UI Scenes")
## The scene that shows the controls for the game. Should not have its own logic.
@export var controls_screen : PackedScene
## The action press that will close the controls screen
@export var controls_screen_accept_action : String = "ui_accept"
## The scene that appears when the game is paused. Should have its own logic.
@export var pause_screen : PackedScene

var _player_count : int
var _controls_screen : Control
var _pause_menu : PauseMenu


## Set up the game for the number of players specified
func setup(player_count : int) -> void:
	_player_count = player_count
	process_mode = Node.PROCESS_MODE_PAUSABLE
	_controls_screen = controls_screen.instantiate() as Control
	_controls_screen.visible = false
	_pause_menu = pause_screen.instantiate() as PauseMenu
	add_child(_controls_screen)
	add_child(_pause_menu)
	

# Start the game's sequence
func start() -> void:
	await _show_controls()


## Pauses the scene tree and awaits pause menu closure to resume
func pause() -> void:
	get_tree().paused = true
	await _show_pause_menu()
	get_tree().paused = false


func _show_pause_menu() -> bool:
	_pause_menu.open()
	await _pause_menu.closed
	return true


# Coroutine - Shows the controls screen and then closes it after user input
func _show_controls() -> void:
	_controls_screen.visible = true
	await _input_awaiter(controls_screen_accept_action)
	_controls_screen.visible = false
	return


## Coroutine - Wait for the specified input and then return true.
## Returns false if the input is not pressed within the time limit.
func _input_awaiter(action : String, time_limit = -1) -> bool:
	var action_fired := false
	var timer : SceneTreeTimer = null
	if time_limit > 0:
		timer = get_tree().create_timer(time_limit)
	while not action_fired:
		if Input.is_action_pressed(action):
			action_fired = true
		elif timer and timer.time_left == 0:
			return false
		else:
			await get_tree().process_frame
	return true
