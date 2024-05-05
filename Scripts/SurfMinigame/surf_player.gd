class_name SurfPlayer extends Node2D

@export var GRAVITY := Vector2(0, 2)
@export var dive_accel := 30.0
@export var max_horz_speed := 20.0
@export var min_horz_speed := 7.0
@export var max_vert_speed := 25.0
@export var velocity_transfer_factor = 1.0
@export var safe_angle : float
@export var velocity : Vector2 = Vector2.ZERO
@export var escape_velocity : Vector2 = Vector2(0, -5)

var is_dead = false
var id : int

var _is_diving := false
var _device: int
var _game : SurfMinigame
var _grounded : bool = false
var _radius : float = 64
var _debug_vel_line = Line2D.new()
var _debug_orth_line = Line2D.new()
var _debug_norm_line = Line2D.new()
var _airborne_timer := Timer.new()
@onready var gravity := GRAVITY

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	set_process(false)

func init(device: int, player_id: int, game: SurfMinigame):
	_device = device
	_game = game
	id = player_id
	_debug_orth_line.default_color = Color.PALE_VIOLET_RED
	_debug_orth_line.default_color = Color.AQUA
	_debug_vel_line.default_color = Color.FIREBRICK
	_debug_vel_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	_debug_norm_line.top_level = true
	_debug_orth_line.top_level = true
	_airborne_timer.wait_time = 0.25
	_airborne_timer.autostart = false
	_airborne_timer.one_shot = true
	add_child(_debug_vel_line)
	#add_child(_debug_orth_line)
	#add_child(_debug_norm_line)
	add_child(_airborne_timer)


func _process(delta: float):
	if is_dead:
		visible = false
		return
	_handle_input()
	var old_vel := velocity
	velocity += gravity * delta * (3 if _grounded else 1)
	# Add hack to prevent gravity from slowing movement too much
	if velocity.length_squared() < old_vel.length_squared() and _grounded:
		velocity = old_vel
	var new_pos := position + velocity
	#new_pos += delta * gravity if not _grounded else Vector2.ZERO
	if _just_collided(new_pos) and _airborne_timer.is_stopped():
		print("Collision!")
		new_pos = _snap_to_ground(new_pos)
		var angle = _calculate_collision_angle(new_pos, velocity)
		velocity = _calculate_post_impact_velocity(new_pos, velocity)
		if angle > safe_angle:
			velocity /= 4
		_grounded = true
	elif _grounded:
		velocity = _calculate_new_velocity(new_pos, velocity)
		new_pos = _snap_to_ground(new_pos)
	_debug_vel_line.points = [Vector2.ZERO, velocity * 5]
	
	if -velocity.y > -escape_velocity.y and _airborne_timer.is_stopped()\
			and _game.get_curve_at_point(new_pos).get_t_value(new_pos) > 0.9:
		_grounded = false
		_airborne_timer.start()
	
	if not _grounded and _is_diving:
		gravity.y += dive_accel * delta
	elif not _grounded:
		gravity.y -= dive_accel * delta
		gravity.y = max(gravity.y, GRAVITY.y)
	else:
		gravity.y = GRAVITY.y
	
	velocity.x = clamp(velocity.x, min_horz_speed if _grounded else 0, max_horz_speed)
	velocity.y = clamp(velocity.y, -max_vert_speed, max_vert_speed)
	position = new_pos


func _handle_input() -> void:
	if MultiplayerInput.is_action_pressed(_device, "dive") and not _grounded:
		_is_diving = true
	elif not MultiplayerInput.is_action_pressed(_device, "dive"):
		_is_diving = false


func _just_collided(pos: Vector2) -> bool:
	# Only count first collision with ground
	if _grounded:
		return false
	if pos.y + _radius > _game.height_at_point(pos).y:
		return true
	return false


func _snap_to_ground(pos: Vector2) -> Vector2:
	pos.y = _game.height_at_point(position).y - _radius
	return pos


func _calculate_post_impact_velocity(pos: Vector2, vel: Vector2) -> Vector2:
	return _calculate_new_velocity(pos, vel) * velocity_transfer_factor


func _calculate_new_velocity(pos: Vector2, vel: Vector2):
	var normal := _game.normal_at_point(pos).normalized()
	var orthoganal := normal.orthogonal().normalized()
	# NOTE: Debug
	var ground_pos = _game.height_at_point(pos)
	_debug_orth_line.points = [ground_pos + orthoganal * 50, ground_pos]
	_debug_norm_line.points = [ground_pos, normal * 50 + ground_pos]
	return orthoganal * vel.length()


func _calculate_collision_angle(pos: Vector2, vel: Vector2) -> float:
	var normal := _game.normal_at_point(pos).normalized()
	var orthoganal := normal.orthogonal().normalized()
	return rad_to_deg(orthoganal.angle_to(vel))


func dive() -> void:
	velocity.y -= dive_accel
