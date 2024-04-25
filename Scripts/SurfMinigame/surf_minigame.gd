class_name SurfMinigame extends IMinigame

#region Constants

#endregion

@export var terrain_pieces : Array[PackedScene] = []
@export var base_speed := 10
@export var safe_angle := 90
@export var min_safe_angle := 25
@export var zoom_factor := 1
@onready var camera = $Camera2D as Camera2D
var terrain_pool : Array[Node2D] = []

func setup(player_count : int) -> void:
	super.setup(player_count)
	for i in range(10):
		_spawn_terrain_piece()

func _process(delta):
	if terrain_pool.is_empty():
		return
	if terrain_pool[0].position.x < camera.position.x - 4000:
		terrain_pool.push_back(terrain_pool.pop_front())
		terrain_pool[-1].position = terrain_pool[-2].get_node("%Spawnpoint").global_position

func _spawn_terrain_piece() -> void:
	var piece := terrain_pieces.pick_random().instantiate() as Node2D
	if terrain_pool.is_empty():
		piece.position = Vector2(-2000, 200)
	else:
		piece.position = terrain_pool.back().get_node("%Spawnpoint").global_position
	terrain_pool.append(piece)
	add_child(piece)


func _on_button_pressed():
	setup(0)
