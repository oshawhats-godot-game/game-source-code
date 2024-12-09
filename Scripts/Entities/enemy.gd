extends Entity
class_name Enemy


@export var Health: float = 5
@export var Knockback: float = 100
@export var KnockbackRecovery: float = 1000

@onready var raycasts = gen_raycasts(16)

@onready var move_dirs = raycasts.map(
	func(x: RayCast2D):
		return x.target_position.normalized()
)

var target_velocity := Vector2.ZERO
var move_velocity := Vector2.ZERO
var direction_preferences: Array

var _speed: float = 0
var _acceleration: float = 0


func _ready() -> void:
	max_health = Health
	health = max_health


func _process(delta: float) -> void:
	update(delta)
	
	if health <= 0:
		_on_death()
		queue_free()


func _physics_process(delta: float) -> void:
	physics_update(delta)
	
	direction_preferences.append(get_avoid_walls_array())
	
	var context_map: Array = get_context_map()
	
	var target_dir = move_dirs[max_ind_array(context_map)]
	
	for child in get_parent().get_children():
		if child is Line2D:
			child.queue_free()
	
	for x in range(len(context_map)):
		var line = Line2D.new()
		get_parent().add_child(line)
		line.add_point(global_position)
		line.add_point(global_position + (move_dirs[x] * 40 * abs(context_map[x])))
		line.modulate = Color.GREEN if context_map[x] > 0 else Color.RED
	
	target_velocity = target_dir * _speed
	
	move_velocity = move_velocity.move_toward(target_velocity, delta * _acceleration)
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * KnockbackRecovery)
	
	velocity = move_velocity + knockback_velocity
	
	move_and_slide()


func move(new_speed, new_acceleration):
	_speed = new_speed
	_acceleration = new_acceleration
	
	direction_preferences = []


func gen_raycasts(num_casts: int):
	var angle_step = (2 * PI) / num_casts
	var _raycasts = []
	
	for x in range(num_casts):
		var new_cast = RayCast2D.new()
		add_child(new_cast)
		new_cast.target_position = Vector2(0, 50).rotated(angle_step * x)
		_raycasts.append(new_cast)
	
	return _raycasts


func get_nearest_targetable_player() -> Player:
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


func get_raycast_info() -> Array:
	var ret = raycasts.map(
		func(x: RayCast2D): return x.is_colliding()
	)
	return ret


func get_context_map():
	var context_map = []
	context_map.resize(len(raycasts))
	context_map.fill(0)
	
	for array in direction_preferences:
		for ind in range(len(array)):
			context_map[ind] += array[ind]
	
	return context_map


func get_preference_array(dir: Vector2, weight: float = 1):
	return move_dirs.map(
		func(x: Vector2):
			return x.dot(dir) * weight
	)


func prefer_dir(dir: Vector2, weight: float = 1):
	direction_preferences.append(get_preference_array(dir, weight))


func get_avoid_walls_array():
	var array = get_raycast_info()
	
	var ret = []
	ret.resize(len(raycasts))
	ret.fill(0)
	
	for ind in range(len(array)):
		var item = array[ind]
		if not item:
			continue
		
		ret[ind] = -5
		
		if ret[ind - 1] == 0:
			ret[ind - 1] = -2
		if ret[ind - 2] == 0:
			ret[ind - 2] = -2
		if ret[ind - (len(raycasts) - 1)] == 0:
			ret[ind - (len(raycasts) - 1)] = -2
		if ret[ind - (len(raycasts) - 2)] == 0:
			ret[ind - (len(raycasts) - 2)] = -2
	
	return ret


func dot_all(start, with):
	var ret = []
	
	for ind in range(len(start)):
		ret.append( start[ind] .dot( with[ind] ) )
	
	return ret


func max_array(array: Array):
	var highest = null
	
	for item in array:
		if (not highest) or item > highest:
			highest = item
	
	return highest


func max_ind_array(array: Array):
	var highest = null
	var highest_ind = 0
	
	for ind in range(len(array)):
		var item = array[ind]
		if (not highest) or item > highest:
			highest = item
			highest_ind = ind
	
	return highest_ind


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func _on_death():
	pass
