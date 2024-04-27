class_name SurfPlayer extends Node2D

@export var gravity := 9.81
@export var dive_accel := 10.0
@export var max_horz_speed := 100.0
@export var max_vert_speed := 500
@export var velocity_transfer_factor = 1.0
@export var safe_angle : float
@export var coll : CollisionShape2D
@export var velocity : Vector2 = Vector2.ZERO

var _is_diving := false
var _device: int
var _game : SurfMinigame
var _grounded : bool = false
var _radius : float = 64

func init(device: int, game: SurfMinigame):
	_device = device
	_game = game


func _process(delta):
	_handle_input()
		
	var new_pos = position + velocity
	var curve := _game.get_curve_at_point(new_pos)
	
	if new_pos.y - _radius < _game.height_at_point(new_pos, curve).y and not _grounded:
		print("Collision!")
		new_pos.y = _game.height_at_point(new_pos, curve).y - _radius
		var normal = _game.normal_at_point(new_pos, curve).normalized()
		velocity = normal * velocity.length() * velocity_transfer_factor * delta
		_grounded = true
	elif _grounded:
		print("Riding the wave!")
		var normal = _game.normal_at_point(position, curve).normalized()
		velocity = normal * velocity.length() * velocity_transfer_factor
		var interp = curve.get_t_value(position + velocity * delta)
		if interp == 1:
			curve = _game.get_curve_at_point(new_pos)
		new_pos = curve.sample(interp * curve.length)
	else:
		print("Falling")
		velocity.y -= .001 * delta
		new_pos += velocity
	position = new_pos
	

func _handle_input():
	if MultiplayerInput.is_action_pressed(_device, "dive") and not _grounded:
		_is_diving = true
	elif MultiplayerInput.is_action_just_released(_device, "dive"):
		_is_diving = false


func dive():
	velocity.y -= dive_accel
