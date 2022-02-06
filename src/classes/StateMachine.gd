extends Node
class_name StateMachine

# States are child nodes.

# Each key is a state node and it's value is a dictionary where each key is an
# event name, and the value is the new state node
var graph := { }
var current_state: Node = null

onready var target := get_parent()


func _ready() -> void:
	var children := get_children()

	current_state = get_child(0)

	for child in children:
		graph[child] = {}

	yield(target, "ready")
	current_state.prepare()


func _process(delta: float) -> void:
	current_state.process(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)


func _input(event: InputEvent) -> void:
	current_state.input(event)


func _unhandled_input(event: InputEvent) -> void:
	current_state.unhandled_input(event)


func run_event(event_name: String) -> void:
	var transitions: Dictionary = graph[current_state]
	var new_state: Node = transitions.get(event_name)

	if new_state:
		current_state = new_state
		current_state.prepare()
