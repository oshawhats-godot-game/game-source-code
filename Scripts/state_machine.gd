extends Node


@export var InitialState : State

var currentState : State
var states : Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if InitialState:
		InitialState.enter()
		currentState = InitialState


func _process(delta: float) -> void:
	if currentState:
		currentState.update(delta)


func _physics_process(delta: float) -> void:
	if currentState:
		currentState.physics_update(delta)


func on_child_transitioned(state: State, new_state_name: String):
	if state != currentState:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if currentState:
		currentState.exit()
	
	new_state.enter()
	currentState = new_state
