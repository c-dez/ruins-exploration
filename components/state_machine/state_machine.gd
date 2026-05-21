extends Node
class_name StateMachine

## Base StateMachine class


@onready var parent: Node3D = get_parent()
@onready var current_state: State = get_child(0)
var states: Dictionary = {}
var last_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# connect child signal
			child.change_state_to.connect(on_state_change_to)

	current_state.enter()


func _process(_delta: float) -> void:
	current_state.process(_delta)

func _physics_process(_delta: float) -> void:
	current_state.physics_process(_delta)


func on_state_change_to(_current_state: State, _new_state: String) -> void:
	if _current_state != current_state:
		return

	var new_state: State = states[_new_state.to_lower()]
	if current_state:
		current_state.exit()

	new_state.enter()
	last_state = current_state
	current_state = new_state