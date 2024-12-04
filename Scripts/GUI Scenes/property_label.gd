extends Label


@export var Target: Node
@export var Property: String


func _ready() -> void:
	if not Target:
		Target = get_parent()


func _process(_delta: float) -> void:
	text = str(Target.get(Property))
