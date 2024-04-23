extends Node2D


var rumble_game = preload("res://Scenes/rumble.tscn") as MiniGame
var pulse_game = preload("res://Scenes/pulse.tscn") as MiniGame
var surf_game = preload("res://Scenes/surf.tscn") as MiniGame



var games_dict = {
	"rumble" : rumble_game,
	"pulse" : pulse_game,
	"surf" : surf_game,
}

var games_count := 3 as int
var score := 0 as int
var current_game := 0 as int
var next_game_num := 0 as int
var next_game: String
var players_num := 0 as int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _modify_score(value: int):
	score += value

func _pick_next_game():
	assert(rumble_game != null)
	assert(pulse_game != null)
	assert(surf_game != null)
	
	var dict_array = games_dict.keys()
	var rand_game := randi() % games_count as int
	next_game = dict_array[rand_game]
	
func _change_to_next_game():
	print("changing game to ")
	print(next_game)
	assert(games_dict["pulse"] != null)
	get_tree().change_scene_to_packed(games_dict["pulse"])
