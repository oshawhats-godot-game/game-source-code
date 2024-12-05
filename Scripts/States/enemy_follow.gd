extends State


@export var enemy: Enemy
@export var speed: float = 50
@export var max_follow_dist: float = 200
@export var min_follow_dist: float = 15

var target: Node2D


func enter():
	target = enemy.get_nearest_targetable_player()


func physics_update(_delta: float):
	var dist = enemy.global_position.distance_to(target.global_position)
	var dir = enemy.global_position.direction_to(target.global_position)
	
	if dist > 15:
		enemy.velocity = dir * speed
	else:
		enemy.velocity = Vector2.ZERO
	
	if dist > max_follow_dist:
		Transitioned.emit(self, "idle")
