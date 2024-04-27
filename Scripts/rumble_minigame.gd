class_name RumbleMinigame extends IMinigame

var players_count : int
var players := {
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	players_count = 1#PlayerManager.get_player_count()
	setup(players_count)
	await start() #the following I think should only start after the player presses a button to close the controls screen Edit: it doesn't wait, apparently - not sure why
	print("test")
	for i in (players_count):
		players[i] = (load("res://Resources/rumble_player.tscn")).instantiate() as RumblePlayer
		print("instantiated player")
		print(i)
		players[i].player_id = i
	for i in (players_count):
		players[i].position = Vector2(150, 150)
	
	var t
	for i in 5:
		for j in 5:
			t = load("res://Resources/transmission_tower.tscn").instantiate()
			(t.position).x = i*64
			(t.position).y = j*64
			print(t.position)
			
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
