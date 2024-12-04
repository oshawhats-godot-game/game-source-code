extends Entity
class_name Enemy


@export var Health: float = 5
@export var Speed: float = 100
@export var Knockback: float = 100
@export var KnockbackRecovery: float = 1000


func _ready() -> void:
	max_health = Health
	health = max_health


func get_nearest_player() -> Player:
	var nearest_player = null
	var nearest_player_dist = INF
	
	for body in $TargetArea.get_overlapping_bodies():
		if not body is Player:
			continue
		
		var dist_to_body = position.distance_squared_to(body.position)
		if dist_to_body >= nearest_player_dist:
			continue
		
		nearest_player = body
		nearest_player_dist = dist_to_body
	
	return nearest_player
