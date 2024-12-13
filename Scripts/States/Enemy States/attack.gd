extends EnemyState


@export var max_follow_dist: float = 500
@export var too_far_state: State

var target: Node2D


func enter():
	target = enemy.get_nearest_targetable_player()


func physics_update(_delta: float):
	var dist = enemy.global_position.distance_to(target.global_position)
	
	enemy.move(speed, acceleration)
	
	enemy.prefer_dir(enemy.global_position.direction_to(target.global_position))
	
	if dist > max_follow_dist:
		Transitioned.emit(self, too_far_state.name)
