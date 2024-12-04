extends Item
class_name Weapon


@export var PointTowardMouse: bool = false

var hit_targets: Array[Entity] = []

func _ready() -> void:
	$ChildHolder/HitArea.connect("body_entered", _HitArea_body_entered)


func _physics_process(_delta: float) -> void:
	
	if PointTowardMouse:
		point_toward_mouse()


func point_toward_mouse(rotation_offset: float = 0):
	if using:
		return
	look_at(get_global_mouse_position())
	rotate(rotation_offset)

func _HitArea_body_entered(_body):
	pass
