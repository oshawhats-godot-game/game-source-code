extends Enemy


enum states {
	STILL,
	CHASE,
}

var state: states = states.STILL
var target_player: Player
var attack_cooldown: float = 3
var attack_timer: float = 0
var attack_damage: float = 15


func _physics_process(delta: float) -> void:
	if not target_player:
		target_player = get_nearest_player()
	
	match state:
		states.STILL:
			if target_player:
				set_state(states.CHASE)
		
		states.CHASE:
			velocity = global_position.direction_to(target_player.global_position) * Speed
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * KnockbackRecovery)
			velocity += knockback_velocity
			move_and_slide()
			
			attack_timer = max(0, attack_timer - delta)
			
			for body in $HitArea.get_overlapping_bodies():
				if body == target_player and attack_timer == 0:
					body.damage(attack_damage, self, Knockback)
					attack_timer = attack_cooldown
					


func set_state(new_state: states):
	state = new_state
