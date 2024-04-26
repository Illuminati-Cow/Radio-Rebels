class_name SurfMinigame extends IMinigame

#region Constants
const CURVE_RES = 1000
const BAKE_RESOLUTION_PX = 5
#endregion

@export var base_speed := 10
@export var safe_angle := 90
@export var min_safe_angle := 25
@export var zoom_factor := 1
@onready var camera = $Camera2D as Camera2D
var terrain_pool : Array[QuadBezier] = []

func setup(player_count : int) -> void:
	super.setup(player_count)
	#for i in range(10):
		#_spawn_terrain_piece()


func _process(delta):
	if terrain_pool.is_empty():
		return
	if terrain_pool[0].position.x < camera.position.x - 4000:
		terrain_pool.push_back(terrain_pool.pop_front())
		terrain_pool[-1].position = terrain_pool[-2].get_node("%Spawnpoint").global_position


#func _spawn_terrain_piece() -> void:
	#var piece := terrain_pieces.pick_random().instantiate() as Node2D
	#if terrain_pool.is_empty():
		#piece.position = Vector2(-2000, 200)
	#else:
		#piece.position = terrain_pool.back().get_node("%Spawnpoint").global_position
	#terrain_pool.append(piece)
	#add_child(piece)


#func _spawn_terrain_curve(start : Vector2, w : float, h : float) -> void:
	#var apex := Vector2(start.x + w / 2, start.y + h)
	#var end := Vector2(start.x + w, start.y)
	#var curve = QuadBezier(start, apex, end)
	#var line = Line2D.new()
	#
	## Tessallate curve to reduce points needed to be drawn
	#var tessallated_points := curve.tessellate()
	#for p in tessallated_points:
		#line.add_point(p)
	#line.position = Vector2(0, 0)
	#add_child(line)
	#var spawnpoint = Marker2D.new()
	#spawnpoint.position = end
	#line.add_child(spawnpoint)
	#
	## WARNING: DEBUG
	#var debug_line = Line2D.new()
	#debug_line.add_point(start)
	#debug_line.add_point(end)
	#debug_line.modulate = Color.VIOLET
	#debug_line.modulate.a = 0.1
	#add_child(debug_line)
	##enddebug




class QuadBezier:
	var start := Vector2.ZERO
	var mid := Vector2.ZERO
	var end := Vector2.ZERO
	var curve := Curve2D.new()
	var _curve_length : float
	
	func _init(start_point: Vector2, mid_point: Vector2, end_point: Vector2):
		start = start_point
		mid = mid_point
		end = end_point
		curve.bake_interval = BAKE_RESOLUTION_PX
		# Load points into curve
		for i in range(CURVE_RES):
			curve.add_point(_sample(float(i) / CURVE_RES))
		curve.add_point(end)
		_curve_length = curve.get_baked_length()
	
	
	func sample(t: float) -> Vector2:
		return curve.sample_baked(t, false)
	
	
	# Source: https://stackoverflow.com/a/39426346
	func normal_at_sample(t: float) -> Vector2:
		var d = _derivative(t)
		var q = sqrt(d.x * d.x + d.y * d.y)

		return Vector2(-d.y / q, d.x / q) 
	
	
	# Source: https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
	func _sample(t: float) -> Vector2:
		var q0 = start.lerp(mid, t)
		var q1 = mid.lerp(end, t)
		return q0.lerp(q1, t)
	
	
	# Source: https://stackoverflow.com/a/38579266
	func _derivative(t: float) -> Vector2:
		return start * (2 * t - 2) + (2 * end - 4 * mid) * t + 2 * mid
