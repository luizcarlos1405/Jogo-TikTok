extends StateMachineState

var grab_distance := 50.0
var grab_offset := Vector2(0, -50.0)
var ceviche_position := Vector2.ZERO
var pirara_position := Vector2.ZERO
var ceviche_distance := 0.0
var ceviche_direction := Vector2.ZERO
var pirara_distance := 0.0
var pirara_direction := Vector2.ZERO

var grabbed_ceviche := false

var speed_up_effect: Effect


func prepare() -> void:
	speed_up_effect = Effect.new(target).sum("speed", 200)
	speed_up_effect.apply()
	target.follow(null)
	ceviche_position = machine.target_ceviche.global_position

	# GO TO CEVICHE
	yield(target.go_to(ceviche_position), "completed")
	grabbed_ceviche = true

	target.follow(target.pirara)



func physics_process(delta: float) -> void:
	var pirara_distance: float = target.global_position.distance_to(target.pirara.global_position)

	if pirara_distance < 10 and grabbed_ceviche:
		var collected_ceviches = State.get_value("collected_ceviches")
		machine.target_ceviche.queue_free()
		machine.target_ceviche = null
		grabbed_ceviche = false
		speed_up_effect.remove()
		machine.run_event("STORED_CEVICHE")
		State.set_value("collected_ceviches", (collected_ceviches as int + 1) as String)

		# TODO: this is not the right place to spawn the dialog
		if collected_ceviches == "6":
			var dialog = Dialogic.start("Sandbox")
			add_child(dialog)

	if grabbed_ceviche:
		machine.target_ceviche.global_position = target.global_position + grab_offset
