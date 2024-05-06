extends RigidBody2D

# Define collision layers and masks
const PLAYER_COLLISION_LAYER = 1
const PLAYER_COLLISION_MASK = 1

@export var speed: float = 200
@export var rectangle_scene_path: String = "res://Rectangle.tscn"

func _process(delta: float) -> void:
	var motion := Vector2.ZERO
	motion = handle_input(motion)  # Get the updated motion vector
	move_player(motion, delta)


func handle_input(motion: Vector2) -> Vector2:
	if Input.is_action_pressed("ui_right"):
		motion.x += 0
	if Input.is_action_pressed("ui_left"):
		motion.x -= 0
	if Input.is_action_pressed("ui_down"):
		motion.y += 0
	if Input.is_action_pressed("ui_up"):
		motion.y -= 0


	return motion

func move_player(motion: Vector2, delta: float) -> void:
	motion = motion.normalized() * speed * delta
	position += motion
