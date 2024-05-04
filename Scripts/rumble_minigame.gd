class_name RumbleMinigame extends IMinigame

@onready var root = get_tree().current_scene
@onready var player_object = load("res://Resources/RumbleMinigame/rumble_player.tscn")
@onready var tower_object = load("res://Resources/RumbleMinigame/transmission_tower.tscn")
@onready var game_timer = root.find_child("Timer")

var players_count : int
var current_players : int
var players := {
	
}

var scores := {
	
}

var eliminated_players = []

#print(root)
#var game_timer : SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	#game_timer = get_tree().create_timer(30)
	#print(game_timer.time_left)
	#game_timer.paused = true
	#game_timer.stop()
	players_count = 1#PlayerManager.get_player_count()
	current_players = players_count
	await get_tree().create_timer(0.2).timeout
	PlayerManager.join(-1)
	if players_count > 1:
		for i in (players_count-1):
			PlayerManager.join(i)
	super.setup(players_count)
	get_tree().paused = true
	await super.start() #the following I think should only start after the player presses a button to close the controls screen Edit: it doesn't wait, apparently - not sure why
	print("test")
	print(_devices)
	
	var t
	for i in 5:	
		for j in 5:
			t = tower_object.instantiate() as TransmissionTower2
			root.add_child(t)
			(t.position).x = i*192 + 400
			(t.position).y = j*192 + 400
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
