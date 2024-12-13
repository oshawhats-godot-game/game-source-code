extends EnemyState


@export var max_follow_dist: float = 500
@export var attack_damage: float = 20
@export var knockback: float = 100
@export var attack_cooldown: float = 2
@export var attack_delay: float = .15

@export var too_far_state: State
@export var hit_area: Area2D

var attack_timer: float = 0
var target: Node2D


func enter():
	target = enemy.get_nearest_targetable_player()


func physics_update(delta: float):
	attack_timer = max(0, attack_timer - delta)
	
	if attack_timer == 0:
		for body in hit_area.get_overlapping_bodies():
			if body is Player:
				attack()
				break
	
	var dist = enemy.global_position.distance_to(target.global_position)
	
	enemy.move(speed, acceleration)
	
	enemy.prefer_dir(enemy.global_position.direction_to(target.global_position))
	
	
	if dist > max_follow_dist:
		Transitioned.emit(self, too_far_state.name)


func attack():
	attack_timer = attack_cooldown
	enemy.get_node("ColorRect").modulate = Color.DARK_RED
	
	await get_tree().create_timer(attack_delay).timeout
	
	for body in hit_area.get_overlapping_bodies():
		if body is Player:
			body.damage(attack_damage, enemy, knockback)
	
	enemy.get_node("ColorRect").modulate = Color.WHITE
