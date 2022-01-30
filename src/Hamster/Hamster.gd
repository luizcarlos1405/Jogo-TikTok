extends Character

export var dog_path := NodePath("../Dog")
export var base_distance_from_dog := 260.0

onready var dog = get_node(dog_path)


func _physics_process(delta: float) -> void:
	var vector_to_dog: Vector2 = dog.global_position - global_position
	input_direction = vector_to_dog - vector_to_dog.clamped(base_distance_from_dog)
