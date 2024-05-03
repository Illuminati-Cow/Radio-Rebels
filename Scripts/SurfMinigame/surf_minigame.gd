class_name SurfMinigame extends IMinigame

#region Constants
const CURVE_RES = 1000
const BAKE_RESOLUTION_PX = 5
#endregion
@export_group("Player")
@export var player_res : PackedScene
@export var base_speed := 10
@export var max_safe_angle := 90.0
@export var min_safe_angle := 25.0
@export var safe_angle : float
@export var difficulty_max_time : float
@export_group("Camera")
@export var zoom_factor := 1
@onready var camera = $Camera2D as Camera2D
var _players : Array[SurfPlayer]
var _dead_players : Dictionary
var terrain_pool : Array[Terrain] = []
var _time : float = 0


func _ready():
	await get_tree().create_timer(0.15).timeout
	setup(1)


func setup(player_count : int) -> void:
	PlayerManager.join(0)
	super.setup(player_count)
	_spawn_terrain_piece($Spawnpoint.global_position - Vector2(1000, 0), 1000, -800)
	var flip = 1
	for i in range(10):
		_spawn_terrain_piece(terrain_pool[-1].visual.get_node("Spawnpoint").global_position, \
				1000, 800 * flip)
		flip = -flip
	for device in _devices:
		var player := player_res.instantiate() as SurfPlayer
		player.init(device, id, self)
		player.name = "Player %d" % id
		player.position = $Spawnpoint.position + Vector2(100, -500)
		add_child(player, true)
		_players.append(player)
	start()


func start():
	print("Start")
	await super.start()
	_time = 0
	for player in _players:
		player.set_process(true)


func height_at_point(position: Vector2, curve: QuadBezier = null) -> Vector2:
	if not curve:
		curve = _get_curve(position)
	var interp = curve.get_t_value(position)
	return curve.sample(interp)

func normal_at_point(position: Vector2, curve: QuadBezier = null) -> Vector2:
	if not curve:
		curve = _get_curve(position)
	var interp = curve.get_t_value(position)
	return curve.normal_at_sample(interp)


func get_curve_at_point(position: Vector2) -> QuadBezier:
	return _get_curve(position)


func _get_curve(position: Vector2) -> QuadBezier:
	for terrain in terrain_pool:
		var t := terrain.curve.get_t_value(position) as float
		if t >= 0 and t <= 1:
			return terrain.curve
	return null


<<<<<<< HEAD
func _leading_player() -> SurfPlayer:
	var p = _players.duplicate()
	p.sort_custom(func (p1, p2): return p1.position.x > p2.position.x)
	return _players[0]



=======
>>>>>>> a22afd68523c256daef0a9223ce2b8124f6cc837
func _process(delta):
	# Update game state
	_time += delta
	safe_angle = Tween.interpolate_value(max_safe_angle, min_safe_angle - max_safe_angle,\
			_time, difficulty_max_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	for player in _players:
		player.safe_angle = safe_angle
	# Update terrain
	if terrain_pool.is_empty():
		return
<<<<<<< HEAD
	if terrain_pool[0].position.x < camera.position.x - 3000:
		var terrain := terrain_pool.pop_front() as Terrain
		terrain.queue_free()
		_spawn_terrain_piece(terrain_pool[-1].visual.get_node("Spawnpoint").global_position, \
			1000, 800 * _spawn_flip)
		_spawn_flip = -_spawn_flip
	# Update trackpoints
	_winner_trackpoint.position.x = _leading_player().position.x
	for player in _players:
		var rect = get_viewport().get_visible_rect()
		if player.global_position.x < rect.position.x - rect.size.x:
			player.is_dead = true
			_dead_players[player.id] = 1 + _dead_players.keys().size()
	if _players.filter(func (p): return p.is_alive).size() == 1:
		Engine.time_scale = 0.2
		await get_tree().create_timer(1).timeout
		Engine.time_scale = 1
		minigame_over.emit(_dead_players)
=======
	if terrain_pool[0].visual.position.x < camera.position.x - 4000:
		terrain_pool.push_back(terrain_pool.pop_front())
		terrain_pool[-1].position = \
				terrain_pool[-2].visual.get_node("Spawnpoint").global_position
>>>>>>> a22afd68523c256daef0a9223ce2b8124f6cc837


func _spawn_terrain_piece(start : Vector2, w : float, h : float) -> void:
	var apex := Vector2(start.x + w / 2, start.y + h)
	var end := Vector2(start.x + w, start.y)
	var curve := QuadBezier.new(start, apex, end)
	var visual := curve.create_visual(1000, Color.GREEN)
	add_child(visual)
	terrain_pool.append(Terrain.new(curve, visual))


class Terrain:
	var curve
	var visual
	
	func _init(bezier_curve: QuadBezier, bezier_visual):
		curve = bezier_curve
		visual = bezier_visual


class QuadBezier:
	var start := Vector2.ZERO
	var mid := Vector2.ZERO
	var end := Vector2.ZERO
	var curve := Curve2D.new()
	var length : float : 
		get:
			return curve.get_baked_length()
	
	func _init(start_point: Vector2, mid_point: Vector2, end_point: Vector2):
		start = start_point
		mid = mid_point
		end = end_point
		curve.bake_interval = BAKE_RESOLUTION_PX
		# Load points into curve
		for i in range(CURVE_RES):
			curve.add_point(_sample(float(i) / CURVE_RES))
		curve.add_point(end)
	
	
	func sample(t: float) -> Vector2:
		return curve.sample_baked(t, false)
	
	
	# Source: https://stackoverflow.com/a/39426346
	func normal_at_sample(t: float) -> Vector2:
		var d = _derivative(t)
		var q = sqrt(d.x * d.x + d.y * d.y)

		return Vector2(-d.y / q, d.x / q) 
	
	
	func get_t_value(position: Vector2) -> float:
		return (position.x - start.x) / (end.x - start.x)
	
	
	func create_visual(depth: float = sample(0.5).y, color: Color = Color.WHITE) -> Polygon2D:
		var poly = Polygon2D.new()
		poly.antialiased = true
		poly.color = color
		poly.polygon.resize(CURVE_RES)
		poly.polygon.fill(Vector2.ZERO)
		var points = []
		# Tessallate curve to reduce points needed to be drawn
		for p in curve.tessellate():
			points.append(p)
		poly.position = Vector2(0, 0)
		points.append(Vector2(end.x, sample(0.5).y + depth))
		points.append(Vector2(start.x, sample(0.5).y + depth))
		poly.polygon = points
		# Spawnpoint for next curve
		var spawnpoint = Marker2D.new()
		spawnpoint.position = end
		spawnpoint.name = "Spawnpoint"
		poly.add_child(spawnpoint, true)
		
		return poly
	
	
	# Source: https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
	func _sample(t: float) -> Vector2:
		var q0 = start.lerp(mid, t)
		var q1 = mid.lerp(end, t)
		return q0.lerp(q1, t)
	
	
	# Source: https://stackoverflow.com/a/38579266
	func _derivative(t: float) -> Vector2:
		return start * (2 * t - 2) + (2 * end - 4 * mid) * t + 2 * mid
