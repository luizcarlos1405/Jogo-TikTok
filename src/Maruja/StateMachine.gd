extends StateMachine


var target_ceviche: Node = null


func _ready() -> void:
	graph[$FollowPirara] = {
		FOUND_CEVICHE = $FetchCeviche
	}
	graph[$FetchCeviche] = {
		STORED_CEVICHE = $FollowPirara
	}


func _process(delta: float) -> void:
	pass

