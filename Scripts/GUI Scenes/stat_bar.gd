extends ProgressBar


@export var Property: String
@export var MaxProperty: String
@export var Target: Node2D


func _ready() -> void:
	max_value = Target.get(MaxProperty)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = Target.get(Property)
