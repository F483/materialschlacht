extends Node2D

class_name StateMachine

var state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(change_state)
	change_state("Default", {})

func change_state(next_state_name, kwargs):
	var new_state = states.get(next_state_name)
	assert(new_state, "State %s not found!" % next_state_name)
	if state:
		state.exit()
	new_state.enter(kwargs)
	state = new_state

func _process(delta):
	if state:
		state.process(delta)

func _physics_process(delta):
	if state:
		state.physics_process(delta)
