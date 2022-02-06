extends Character

export var pirara_path := NodePath("../Pirara")
export var base_distance_from_pirara := 260.0

onready var pirara = get_node(pirara_path)


func _process(delta: float) -> void:
	$CevicheDetection.global_position = pirara.global_position
