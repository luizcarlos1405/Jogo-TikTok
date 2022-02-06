extends Node

class_name StateMachineState

onready var machine := get_parent()
onready var target := machine.get_parent()


func prepare() -> void: pass
func process(delta: float) -> void: pass
func physics_process(delta: float) -> void: pass
func input(event: InputEvent) -> void: pass
func unhandled_input(event: InputEvent) -> void: pass
