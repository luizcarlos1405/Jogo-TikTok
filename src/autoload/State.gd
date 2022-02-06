extends Node

var _state := {
	collected_ceviches = { subscriptions = [], value = "0" }
}

func set_value(key: String, value = null, type = null) -> void:
	var key_data: Dictionary = _state.get(key, { subscriptions = [], value = null })

	key_data.value = value

	for subscription in key_data.subscriptions:
		subscription.object.set(subscription.property, key_data.value)


func get_value(key: String):
	var key_data: Dictionary = _state.get(key, { subscriptions = [], value = null })

	return key_data.value


func subscribe(key: String, object: Object, property: String) -> void:
	var key_data: Dictionary = _state.get(key, { subscriptions = [], value = null })

	key_data.subscriptions.append({ object = object, property = property })

