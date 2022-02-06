extends KinematicBody2D

class_name TopdownMovement

export var acceleration := 900.0
export var speed := 1000.0
export var velocity := Vector2.ZERO

var input_direction := Vector2.ZERO

var _target_velocity := Vector2.ZERO
var _target_node: Node2D = null
var _distance_from_target := 260.00
var _target_position := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if _target_node:
		var direction_from_target_to_self := (global_position - _target_node.global_position).normalized()
		var vector_to_target := _target_node.global_position - global_position

		input_direction = vector_to_target - vector_to_target.clamped(_distance_from_target)

	input_direction = input_direction.normalized()
	_target_velocity = input_direction * speed

	velocity = velocity.move_toward(_target_velocity, acceleration * delta)
	velocity = move_and_slide(_target_velocity)


func go_to(global_point: Vector2) -> void:
	var distance = global_position.distance_to(global_point)
	input_direction = global_position.direction_to(global_point)

	yield(get_tree().create_timer(distance / speed), "timeout")

	input_direction = Vector2.ZERO


func follow(target: Node2D, distance_from_target: float = 0.0) -> void:
	_target_node = target
	_distance_from_target = distance_from_target
