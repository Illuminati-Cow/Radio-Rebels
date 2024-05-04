class_name RumbleMinigame extends IMinigame

@onready var root = get_tree().current_scene
@onready var player_object = load("res://Resources/rumble_player.tscn")
@onready var tower_object = load("res://Resources/transmission_tower.tscn")

var players_count : int
var players := {
	
}

var scores := {
	
}

var eliminated_players = []

#print(root)
#var game_timer : SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	players_count = 1#PlayerManager.get_player_count()
	setup(players_count)
	await start() #the following I think should only start after the player presses a button to close the controls screen Edit: it doesn't wait, apparently - not sure why
	print("test")
	for i in (players_count):
		players[i] = player_object.instantiate() as RumblePlayer
		root.add_child(players[i])
		print("instantiated player")
		#print(i)
		players[i].player_id = i
		print(players[i].player_id)
	for i in (players_count):
		players[i].position = Vector2(150, 150)
		print("players[i].position:")
		print(players[i].position)
	
	var t
	for i in 5:
		for j in 5:
			t = tower_object.instantiate() as TransmissionTower2
			root.add_child(t)
			(t.position).x = i*64
			(t.position).y = j*64
			#print(t.position)

	var j = 0
	for device in (_devices):
		j = j+1
		players[device] = player_object.instantiate() as RumblePlayer
		root.add_child(players[device])
		print("instantiated player")
		#print(i)
		#players[devices].player_id = i
		players[device].device_num = _devices[device]
		players[device].position = Vector2(j*2*192+400, 2*192+400)
		#print(players[i].player_id)
		scores[device] = players_count
	
	get_tree().paused = false
	game_timer.paused = false
	game_timer.start(30)
			
	
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
		#for i in eliminated_players:
			#scores[i] = 
			
		minigame_over.emit(scores)
		#get_tree().change_scene_to_file("res://Scenes/transition_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	print(game_timer.time_left)
	if game_timer.time_left < 0.001:
		print("minigame over")
		var places = players_count-eliminated_players.size()
		for i in places:
			scores[eliminated_players.pop_back()] = players_count-i
		minigame_over.emit(scores)
		#get_tree().change_scene_to_file("res://Scenes/transition_scene.tscn")
