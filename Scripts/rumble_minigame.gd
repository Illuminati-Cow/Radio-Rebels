class_name RumbleMinigame extends IMinigame

@onready var root = get_tree().current_scene
@onready var player_object = load("res://Resources/RumbleMinigame/rumble_player.tscn")
@onready var tower_object = load("res://Resources/RumbleMinigame/transmission_tower.tscn")

var players_count : int
var current_players : int
var players := {
	
}

var scores := {
	
}

var eliminated_players = []

#print(root)
var game_timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_over.connect(GameManager._on_minigame_over)
	players_count = PlayerManager.get_player_count()
	setup(players_count)
	_controls_screen.reparent($CanvasLayer)
	await start()
	for i in range(5):
		for j in range(5):
			var t = tower_object.instantiate() as TransmissionTower
			t.add_to_group("tower")
			add_child(t)
			(t.position).x = i*192+400
			(t.position).y = j*192+380

	var j = 1
	for id in (_devices):
		players[id] = player_object.instantiate() as RumblePlayer
		players[id].add_to_group("player")
		add_child(players[id])
		players[id].device_num = _devices[id]
		players[id].position = Vector2(j*2*192+400, 2*192+340)
		players[id].modulate = player_colors[id]
		scores[id] = players_count
		j += 1
	add_child(game_timer)
	game_timer.start(30)
	game_timer.timeout.connect(_on_game_time_out)
	current_players = players_count
			
	
func _player_eliminated(device):
	print("player eliminated")
	current_players = current_players - 1
	print("current players:")
	print(current_players)
	eliminated_players.append(device)
	if current_players <= 1:
		#eliminated_players.append((root.find_child("RumblePlayer")).device_num)
		print("minigame over")
		var places = players_count-1
		for i in places:
			scores[eliminated_players.pop_back()] = players_count-i
		Engine.time_scale = 0.2
		await get_tree().create_timer(2*0.2).timeout
		Engine.time_scale = 1
		minigame_over.emit(scores)
		#get_tree().change_scene_to_file("res://Scenes/transition_scene.tscn")


func _on_game_time_out():
	print(game_timer.time_left)
	if game_timer.time_left < 0.001:
			print("minigame over")
			var places = players_count-eliminated_players.size()
			for i in places:
				scores[eliminated_players.pop_back()] = players_count-i
			minigame_over.emit(scores)
