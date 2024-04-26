class_name RumbleMinigame extends IMinigame

var players_count : int
var players := {
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	players_count = PlayerManager.get_player_count()
	setup(players_count)
	start() #the following I think should only start after the player presses a button to close the controls screen
	for i in (players_count):
		players[i] = get_node("res://Resources/rumble_player.tscn").instantiate() as RumblePlayer
		players[i].playerId = i
	for i in (players_count):
		players[i].transform.origin 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
