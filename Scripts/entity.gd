extends CharacterBody2D
class_name Entity


var max_health: float
var health: float
var knockback_velocity: Vector2


func damage(_damage: float, other: Entity, knockback: float):
	_on_hit(_damage, other)
	
	health -= _damage
	
	var knockback_dir = other.global_position.direction_to(global_position)
	knockback_velocity = knockback_dir * knockback


func _on_hit(_damage: float, _other: Entity):
	pass
