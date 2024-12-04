extends Weapon

@export var SwingDamage: float = 5
@export var SwingAngle: float = 45
@export var SwingTime: float = 1.5

@export var StabDamage: float = 2
@export var StabDepth: float = 20
@export var StabTime: float = .5

@export var Knockback: float = 500

var curr_damage: float
var tween: Tween


func _process(_delta: float) -> void:
	if using:
		return
	
	if Input.is_action_just_pressed("main_attack"):
		swing_attack()
	
	if Input.is_action_just_pressed("secondary_attack"):
		stab_attack()


func _HitArea_body_entered(body):
	if not using:
		return
	
	try_damage_body(body)


func wait_and_reset_tween():
	if tween:
		await tween.finished
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)


func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)


func swing_attack() -> void:
	start_attack(SwingDamage)
	
	tween.tween_property($ChildHolder, "rotation_degrees", -SwingAngle, SwingTime/4)
	await wait_and_reset_tween()
	
	tween.tween_property($ChildHolder, "rotation_degrees", SwingAngle, SwingTime/2)
	await wait_and_reset_tween()
	
	tween.tween_property($ChildHolder, "rotation_degrees", 0, SwingTime/4)
	await wait_and_reset_tween()
	
	finish_attack()


func stab_attack():
	start_attack(StabDamage)
	
	tween.tween_property($ChildHolder, "position", Vector2(StabDepth, 0), StabTime/2)
	await wait_and_reset_tween()
	
	tween.tween_property($ChildHolder, "position", Vector2.ZERO, StabTime/2)
	await wait_and_reset_tween()
	
	finish_attack()


func start_attack(damage: float):
	using = true
	curr_damage = damage
	reset_tween()
	
	try_damage_bodies($ChildHolder/HitArea.get_overlapping_bodies())


func finish_attack():
	using = false
	hit_targets = []
	tween.kill()


func try_damage_body(body):
	if not body is Entity:
		return
	
	if body is Player:
		return
	
	if body in hit_targets:
		return
	
	body.damage(curr_damage, holder, Knockback)
	hit_targets.append(body)


func try_damage_bodies(bodies):
	for body in bodies:
		try_damage_body(body)
