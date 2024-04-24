class_name PauseMenu extends Control

signal closed

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		closed.emit()


func _on_close_button_pressed():
	closed.emit()


func _on_closed():
	visible = false


func open():
	visible = true
