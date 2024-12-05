extends State


@export var enemy: Enemy
@export var speed: float = 20
@export var max_home_dist: float = 50
@export var min_travel_dist: float = 15
@export var min_rest_time: float = 1
@export var max_rest_time: float = 2.5

var home_pos := Vector2.ZERO
var target_pos: Vector2
var rest_timer: float = 0.0


func randomize_position():
	var offset = Vector2.ZERO
	offset.x = randf_range(-1, 1)
	offset.y = randf_range(-1, 1)
	
	offset = offset.normalized()
	offset *= randf() * max_home_dist
	
	target_pos = home_pos + offset
	
	if enemy.global_position.distance_to(target_pos) < min_travel_dist:
		randomize_position()


func enter():
	home_pos = enemy.global_position
	rest_timer = max_rest_time
	randomize_position()


func physics_update(delta: float):
	if enemy.get_nearest_targetable_player():
		Transitioned.emit(self, "follow")
		return
	
	if rest_timer:
		rest_timer = max(0, rest_timer - delta)
		return
	
	var dist = enemy.global_position.distance_to(target_pos)
	
	if dist < 1:
		rest_timer = randf_range(min_rest_time, max_rest_time)
		randomize_position()
	
	var move_dir = enemy.global_position.direction_to(target_pos)
	
	enemy.velocity = move_dir * speed
	
	if 0 < enemy.get_real_velocity().length() and enemy.get_real_velocity().length() < speed * .99 :
		randomize_position()
