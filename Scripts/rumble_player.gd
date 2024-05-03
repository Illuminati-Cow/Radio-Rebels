class_name RumblePlayer extends Area2D

#var inputs = {
#	"move_right": Vector2.RIGHT,
#	"move_left": Vector2.LEFT,
#	"move_up": Vector2.UP,
#	"move_down": Vector2.DOWN
#}

@export var player_id := -1 as int
@export var device_num = 0
@export var entered_tower_time := 0 as float
signal destroyed_other_player
var overlapping_player := false as bool
var x_axis := 0 as float
var y_axis := 0 as float

var held_count := 0 as float

# Called when the node enters the scene tree for the first time.
func _ready():
	var rumble_node = get_tree().current_scene#).find_child("Rumble")
	destroyed_other_player.connect(rumble_node._player_eliminated)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(player_id)
	var direction = MultiplayerInput.get_vector(device_num, "move_right", "move_left", "move_up", "move_down")
	#print(direction)
	if direction != Vector2(0, 0):
		#print(player_id)
		#print("holding direction")
		if abs(direction.x) >= abs(direction.y):
			x_axis = -1 * (direction.x/abs(direction.x)) #this expression gets the sign of the direction
			y_axis = 0
		else:
			y_axis = 1 * (direction.y/abs(direction.y)) #this expression gets the sign of the direction
			x_axis = 0
		
		held_count += 1000*delta #add the number of milliseconds since the last frame
		if held_count >= 1000:
			held_count = 0
			if (position.x)+(192 * x_axis) <= (4*192 + 400) && (position.x)+(192 * x_axis) >= (400):
				position.x = position.x + (192 * x_axis)
			if (position.y)+(192 * y_axis) <= (4*192 + 400) && (position.y)+(192 * y_axis) >= (400):
				position.y = position.y + (192 * y_axis)
	else:
		x_axis = 0
		y_axis = 0
		held_count = 0

func _on_RumblePlayer_area_entered(area):
	if area.is_in_group("towers"):
		entered_tower_time = Time.get_ticks_msec()
		print("entered tower at:")
		print(entered_tower_time)
	if area.is_in_group("player"):
		print ("overlapping other player")
		overlapping_player = true
		print(entered_tower_time)
		print(area.entered_tower_time)
		if area.entered_tower_time < entered_tower_time:
			destroyed_other_player.emit()
			area.queue_free()
			print("eliminated other player")
