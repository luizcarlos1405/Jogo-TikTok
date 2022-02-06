extends Node # For it to enter the tree and use timers...

class_name Effect

enum { EFFECT_MULTIPLY, EFFECT_SUM, EFFECT_SET_BOOL, EFFECT_CALL_METHODS }

signal applied
signal removed

var effects: Array = []
var timer := Timer.new()
var active: bool = false
var parent: Node


func _init(parent:Node):
	self.parent = parent
	self.parent.add_child(self) # So it can use timers and other stuff
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer) # Everyone with self, not letting this one alone


func multiply(property: String, factor: float, custom_object: Object = null) -> Effect:
	if factor == 0.0:
		print("[ERROR]: cannot apply a multiply method by the factor of 0. Would not be able to divide back later.")
		return self

	var effect = {}
	effect.type = EFFECT_MULTIPLY
	effect.object = custom_object if custom_object else parent
	effect.property = property
	effect.factor = factor

	effects.append(effect)

	return self


func sum(property: String, addend: float, custom_object: Object = null) -> Effect:
	var effect = {}
	effect.type = EFFECT_SUM
	effect.object = custom_object if custom_object else parent
	effect.property = property
	effect.addend = addend

	effects.append(effect)
	return self


func set_bool(property: String, value: bool, custom_object: Object = null) -> Effect:
	var effect = {}
	effect.type = EFFECT_SET_BOOL
	effect.object = custom_object if custom_object else parent
	effect.property = property
	effect.value = value

	effects.append(effect)
	return self


func call_methods(apply_method: String, remove_method: String, args := [], custom_object: Object = null) -> Effect:
	var effect = {}
	effect.type = EFFECT_CALL_METHODS
	effect.object = custom_object if custom_object else parent
	effect.apply_method = apply_method
	effect.remove_method = remove_method
	effect.args = args

	if not effect.object.has_meta(apply_method) or not effect.object.has_method(remove_method):
		print("[ERROR]: method %s or %s not found. Make sure both exist." % [apply_method, remove_method])
		return self

	effects.append(effect)
	return self


func apply(time: float = -1) -> void:
	timer.stop()

	# If a time is passed start the timer, if it is already active, then the effect restarts the timer
	if time > 0:
		timer.start(time)
	elif time == 0:
		return

	if active: return

	for effect in effects:
		var property_value = effect.object.get(effect.property)

		if property_value == null:
			print("[ERROR]: couldn't get property %s, is it a real property of %s? The effect %s will not be applied." % [effect.property, effect.object.get_name(), effect.type])
			continue

		match effect.type:
			EFFECT_MULTIPLY:
				effect.object.set(effect.property, property_value * effect.factor)
			EFFECT_SUM:
				effect.object.set(effect.property, property_value + effect.addend)
			EFFECT_SET_BOOL:
				effect.object.set(effect.property, effect.value)
			EFFECT_CALL_METHODS:
				effect.object.call(effect.apply_method)
			_:
				print("[ERROR] effect type %s not found. The effect %s on %s will not be applied." % [effect.type, effect.value, effect.object.get_name()])

	active = true

	emit_signal("applied")


func remove() -> void:
	if not active: return

	for effect in effects:
		var property_value = effect.object.get(effect.property)
		if property_value == null:
			print("[ERROR]: couldn't get property %s, is it a real property of %s? The effect %s will not be removed." % [effect.property, effect.object.get_name(), effect.type])
			continue

		match effect.type:
			EFFECT_MULTIPLY:
				effect.object.set(effect.property, property_value / effect.factor)
			EFFECT_SUM:
				effect.object.set(effect.property, property_value - effect.addend)
			EFFECT_SET_BOOL:
				effect.object.set(effect.property, not effect.value)
			EFFECT_CALL_METHODS:
				effect.object.call(effect.remove_method)

	active = false

	emit_signal("removed")


func toggle() -> void:
	if active: remove()
	else: apply()


func set_active(value:bool):
	if value: apply()
	else: remove()


func _on_Timer_timeout():
	remove()
