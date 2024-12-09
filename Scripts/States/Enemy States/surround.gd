extends EnemyState


@export var max_follow_dist: float = 500
@export var max_circle_radius: float = 125
@export var min_circle_radius: float = 75
@export var too_far_state: State

var target: Node2D
var target_offset: Vector2
var circle_radius: float


func randomize_target_offset():
	circle_radius = randf_range(min_circle_radius, max_circle_radius)
	
	target_offset.x = randf()
	target_offset.y = randf()
	
	target_offset = target_offset.normalized() * circle_radius


func enter():
	target = enemy.get_nearest_targetable_player()
	
	randomize_target_offset()


func physics_update(_delta: float):
	var target_pos = target.global_position + target_offset
	
	var dist = enemy.global_position.distance_to(target.global_position)
	var dir = enemy.global_position.direction_to(target_pos)
	
	enemy.move(speed, acceleration)
	
	enemy.prefer_dir(enemy.global_position.direction_to(target.global_position))
	
	if dist > max_follow_dist:
		Transitioned.emit(self, too_far_state.name)
