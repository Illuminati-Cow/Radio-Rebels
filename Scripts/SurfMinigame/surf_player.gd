class_name SurfPlayer extends CharacterBody2D

@export var dive_accel := 10.0
@export var max_horz_speed := 100.0
@export var max_vert_speed := 500
@export var velocity_transfer_factor = 1.0

var _is_diving := false

func _physics_process(delta):
	move_and_slide()

func dive():
	velocity.y -= dive_accel
