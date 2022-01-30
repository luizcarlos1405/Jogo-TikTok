extends PlatformerMovement

class_name Character


func _process(delta: float) -> void:
	animate()


func animate() -> void:
	if velocity.x < 0:
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$Sprite.flip_h = false

	if velocity.length() > 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("RESET")
