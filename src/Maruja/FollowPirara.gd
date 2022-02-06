extends StateMachineState

export var ceviche_detection_path := NodePath("../../CevicheDetection")

onready var ceviche_detection: Area2D = get_node(ceviche_detection_path)


func prepare() -> void:
	target.follow(target.pirara, target.base_distance_from_pirara)


func _process(delta: float) -> void:
	var close_ceviches := ceviche_detection.get_overlapping_areas()

	if not close_ceviches.empty() and not machine.target_ceviche:
		machine.target_ceviche = close_ceviches[0]
		machine.run_event("FOUND_CEVICHE")
