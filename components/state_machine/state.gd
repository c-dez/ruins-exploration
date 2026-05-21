extends Node
class_name State

## Base State class

@onready var sm: StateMachine = get_parent()
signal change_state_to(current_state: State, new_state: String)


func enter() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func exit() -> void:
	pass
