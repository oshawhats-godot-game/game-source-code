extends Entity
class_name Player

enum direction {
	LEFT,
	RIGHT,
}

const OFFSET_TO_TURN = 15

const BASE_SPEED: float = 250
const BASE_ACCELERATION: float = BASE_SPEED * 10
const BASE_KNOCKBACK_RECOVERY: float = 750

const BASE_MAX_HEALTH: float = 100
const BASE_HEALTH_REGEN: float = 5
const BASE_REGEN_HIT_DELAY: float = 5

const BASE_MAX_STAMINA: float = 100
const BASE_STAMINA_REGEN: float = 10
const BASE_STAMINA_REGEN_DELAY: float = 3

const SPRINT_SPEED_BOOST: float = BASE_SPEED * .3
const SPRINT_STAMINA_DRAIN: float = 15

var speed: float
var acceleration: float

var health_regen: float

var max_stamina: float
var stamina_regen: float

var stamina: float = 0
var stamina_regen_timer: float = 0
var health_regen_timer: float = 0

var selected_item: Item = null
var facing_dir: direction = direction.LEFT

var move_velocity: Vector2 = Vector2.ZERO


func _ready():
	set_stats()
	
	health = max_health
	stamina = max_stamina
	
	selected_item = load("res://Scenes/Items/Weapons/sword.tscn").instantiate()
	get_parent().add_child.call_deferred(selected_item)
	selected_item.holder = self


func _process(delta: float) -> void:
	move(delta)
	
	regen_stats(delta)
	
	set_facing_direction()
	
	match facing_dir:
		direction.LEFT:
			selected_item.global_position = $LeftItemHolder.global_position
		direction.RIGHT:
			selected_item.global_position = $RightItemHolder.global_position


func move(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	)
	
	var sprinting = sprint_if_pressed(move_dir, delta)
	var sprint_boost = SPRINT_SPEED_BOOST if sprinting else 0.0
	
	var target: Vector2 = move_dir * (speed + sprint_boost)
	
	move_velocity = move_velocity.move_toward(target, delta * acceleration)
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * BASE_KNOCKBACK_RECOVERY)
	
	velocity = move_velocity + knockback_velocity
	
	move_and_slide()


func sprint_if_pressed(move_dir: Vector2, delta: float) -> bool:
	if not Input.is_action_pressed("sprint"):
		return false
	
	if stamina == 0:
		return false
	
	if move_dir.length_squared() == 0:
		return false
	
	stamina = max(0, stamina - ( delta * SPRINT_STAMINA_DRAIN ))
	stamina_regen_timer = BASE_STAMINA_REGEN_DELAY
	return true


func regen_stats(delta: float):
	health_regen_timer = max(0, health_regen_timer - delta)
	stamina_regen_timer = max(0, stamina_regen_timer - delta)
	
	if health_regen_timer == 0:
		health = min(max_health, health + ( health_regen * delta ))
		
	if stamina_regen_timer == 0:
		stamina = min(max_stamina, stamina + ( stamina_regen * delta ))


func set_stats():
	speed = BASE_SPEED
	acceleration = BASE_ACCELERATION
	
	max_health = BASE_MAX_HEALTH
	health_regen = BASE_HEALTH_REGEN
	
	max_stamina = BASE_MAX_STAMINA
	stamina_regen = BASE_STAMINA_REGEN


func set_facing_direction():
	if selected_item and selected_item.using:
		return
	
	var to_mouse = get_global_mouse_position() - position
	
	if to_mouse.x > OFFSET_TO_TURN:
		facing_dir = direction.RIGHT
	if to_mouse.x < -OFFSET_TO_TURN:
		facing_dir = direction.LEFT


func _on_hit(_damage: float, _other: Entity):
	health_regen_timer = BASE_REGEN_HIT_DELAY
