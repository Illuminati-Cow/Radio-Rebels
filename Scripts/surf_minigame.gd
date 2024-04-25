class_name SurfMinigame extends IMinigame

#region Constants
@export var AMPLITUDE := 1.0
@export var FREQUENCY := 10.0
@export var SMOOTHING := 1.0
#endregion

var terrain : Array[Line2D] = []


func _spawn_terrain_piece() -> void:
	var line = _generate_sine_wave()
	terrain.append(line)
	add_child(_generate_sine_wave())

func _generate_sine_wave() -> Line2D:
	var line := Line2D.new()
	var points := []
	for i in range(1000):
		points.append(Vector2(i * 10, sin(i * FREQUENCY) * AMPLITUDE))
	line.points = points
	return line


func _on_button_pressed():
	for piece in terrain:
		piece.queue_free()
	terrain.clear()
	_spawn_terrain_piece()
