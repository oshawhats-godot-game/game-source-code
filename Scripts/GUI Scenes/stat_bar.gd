extends ProgressBar


@export var Property: String
@export var MaxProperty: String
@export var Target: Node2D


func _ready() -> void:
	if not Target:
		Target = get_parent()


func _process(_delta: float) -> void:
	max_value = Target.get(MaxProperty)
	value = Target.get(Property)
