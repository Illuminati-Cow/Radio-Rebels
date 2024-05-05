class_name GroupTrackingCamera extends Camera2D

@export var targets : Array[Node2D] = []
@export var tracking_power : float = 0.25
@export var zooming_power : float = 0.4
@export var max_zoom := 2
@export var min_zoom := 0.1
@export var buffer := 500

var _trackpoint : Vector2 = Vector2.ZERO

func _process(delta):
	if targets.size() == 0:
		return
	
	# Track average position of targets
	_trackpoint = _get_avg_target_pos()
	zoom += (_calculate_encompassing_zoom() - zoom) * zooming_power
	
	# Approach trackpoint
	position.x += (_trackpoint.x - position.x) * tracking_power
	position.y += (_trackpoint.y - position.y) * tracking_power


func _get_avg_target_pos() -> Vector2:
	var sum = Vector2.ZERO
	for target in targets:
		sum += target.global_position
	return sum / max(1, targets.size())


func _calculate_encompassing_zoom() -> Vector2:
	# Calculate Zoom required to see all targets
	var max_pos = -Vector2.INF
	for target in targets:
		var t_pos = target.global_position
		max_pos.x = max(abs(_trackpoint.x - t_pos.x), max_pos.x)
		max_pos.y = max(abs(_trackpoint.y - t_pos.y), max_pos.y)
	max_pos = Vector2(max_pos.x + buffer, max_pos.y + buffer)
	var size := get_viewport_rect().size
	var z = 0.5 / max(max_pos.x / size.x, max_pos.y / size.y)
	z = clamp(z, min_zoom, max_zoom)
	
	return Vector2(z, z)
