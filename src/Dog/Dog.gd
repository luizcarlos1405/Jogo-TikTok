extends Character


func _physics_process(delta: float) -> void:
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")


func _ready() -> void:
	pass
