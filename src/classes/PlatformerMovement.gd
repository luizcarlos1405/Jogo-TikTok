extends KinematicBody2D

class_name PlatformerMovement

export var acceleration := 900.0
export var speed := 1000.0
export var velocity := Vector2.ZERO

var input_direction := Vector2.ZERO

var _target_velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	input_direction = input_direction.normalized()
	_target_velocity = input_direction * speed

	velocity = velocity.move_toward(_target_velocity, acceleration * delta)
	velocity = move_and_slide(_target_velocity)


