extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._pick_next_game()
	GameManager._change_to_next_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
