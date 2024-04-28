class_name RumblePlayer extends Area2D

#var inputs = {
#	"move_right": Vector2.RIGHT,
#	"move_left": Vector2.LEFT,
#	"move_up": Vector2.UP,
#	"move_down": Vector2.DOWN
#}

@export var player_id := -1 as int
@export var entered_tower_time := 0 as float
var overlapping_player := false as bool
var x_axis := 0 as float
var y_axis := 0 as float

var held_count := 0 as float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(player_id)
	var direction = MultiplayerInput.get_vector(PlayerManager.get_player_device(player_id), "move_right", "move_left", "move_up", "move_down")
	print(direction)
	if direction != Vector2(0, 0):
		print(player_id)
		print("holding direction")
		if (direction.x).abs() >= (direction.y).abs():
			x_axis = 1 * (direction.x/((direction.x).abs())) #this expression gets the sign of the direction
			y_axis = 0
		else:
			y_axis = 1 * (direction.y/((direction.y).abs())) #this expression gets the sign of the direction
			x_axis = 0
		
		held_count += 1000*delta #add the number of milliseconds since the last frame
		if held_count >= 1000:
			held_count = 0
			position.x = position.x + (64 * x_axis)
			position.y = position.y + (64 * y_axis)
	else:
		x_axis = 0
		y_axis = 0
		held_count = 0

func _on_RumblePlayer_area_entered(area):
	if area.is_in_group("tower"):
		entered_tower_time = Time.get_ticks_msec()
	if area.is_in_group("player"):
		print ("overlapping other player")
		overlapping_player = true
		if area.entered_tower_time > entered_tower_time:
			area.queue_free()
			print("eliminated other player")
