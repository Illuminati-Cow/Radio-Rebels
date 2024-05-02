class_name RumbleMinigame extends IMinigame

@onready var root = get_tree().current_scene
@onready var player_object = load("res://Resources/rumble_player.tscn")
@onready var tower_object = load("res://Resources/transmission_tower.tscn")

var players_count : int
var players := {
	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	players_count = 1#PlayerManager.get_player_count()
	await get_tree().create_timer(0.2).timeout
	PlayerManager.join(-1)
	super.setup(players_count)
	start() #the following I think should only start after the player presses a button to close the controls screen Edit: it doesn't wait, apparently - not sure why
	print("test")
	print(_devices)
	
	for device in (_devices):
		players[device] = player_object.instantiate() as RumblePlayer
		root.add_child(players[device])
		print("instantiated player")
		#print(i)
		#players[devices].player_id = i
		players[device].device_num = _devices[device]
		players[device].position = Vector2(150, 150)
		#print(players[i].player_id)
	
	var t
	for i in 5:
		for j in 5:
			t = tower_object.instantiate() as TransmissionTower
			root.add_child(t)
			(t.position).x = i*64
			(t.position).y = j*64
			#print(t.position)
			
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
