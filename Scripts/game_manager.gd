extends Node2D


var rumble_game = preload("res://Scenes/rumble.tscn")
var pulse_game = preload("res://Scenes/pulse.tscn")
var surf_game = preload("res://Scenes/surf.tscn")
var transition_scene = preload("res://Scenes/transition_scene.tscn")

var games_dict = {
	"rumble" : rumble_game,
	"surf" : surf_game,
}

var games_count := 2 as int
var current_game := ""
var next_game_num := 0 as int
var next_game: String


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	PlayerManager.player_joined.connect(_on_player_joined)
	PlayerManager.player_left.connect(_on_player_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Run this function when you want players to be able to join the game
	# Uncomment or put where you see fit
	# PlayerManager.handle_join_input()
	pass


func _modify_score(player : int, value: int):
	PlayerManager.set_player_data(player, "score", value)


func _pick_next_game():
	assert(rumble_game != null)
	assert(surf_game != null)
	
	var dict_array = games_dict.keys().filter(func (g): return g != current_game)
	next_game = dict_array.pick_random()
	
	
func _change_to_next_game():
	print("changing game to ")
	print(next_game)
	assert(games_dict[next_game] != null)
	current_game = next_game
	get_tree().change_scene_to_packed(games_dict[next_game])


func _transition():
	get_tree().change_scene_to_packed(transition_scene)


func _on_player_joined(player : int):
	# Do something
	print_debug("Player " + str(player) + " joined")
	pass


func _on_player_left(player : int):
	# Do something
	print_debug("Player " + str(player) + " left")
	pass


func _on_minigame_over(scores):
	for id in scores:
		_modify_score(id, scores[id])
	_transition()
