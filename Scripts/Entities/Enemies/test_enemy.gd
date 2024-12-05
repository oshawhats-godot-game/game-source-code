extends Enemy


func _physics_process(delta: float) -> void:
	velocity += knockback_velocity
	move_and_slide()
	
	velocity = Vector2.ZERO
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * KnockbackRecovery)
