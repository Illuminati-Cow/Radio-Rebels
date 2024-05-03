class_name RumbleMinigame extends IMinigame

@onready var root = get_tree().current_scene
@onready var player_object = load("res://Resources/RumbleMinigame/rumble_player.tscn")
@onready var tower_object = load("res://Resources/RumbleMinigame/transmission_tower.tscn")

var players_count : int
var current_players : int
var players := {
	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	players_count = 2#PlayerManager.get_player_count()
	current_players = players_count
	await get_tree().create_timer(0.2).timeout
	PlayerManager.join(-1)
	PlayerManager.join(0)
	super.setup(players_count)
	start() #the following I think should only start after the player presses a button to close the controls screen Edit: it doesn't wait, apparently - not sure why
	print("test")
	print(_devices)
	
	var t
	for i in 5:	
		for j in 5:
			t = tower_object.instantiate() as TransmissionTower
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
			
	
func _player_eliminated():
	current_players == current_players - 1
	if current_players <= 1:
		minigame_over.emit()
		get_tree().change_scene_to_file("res://Scenes/transition_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
