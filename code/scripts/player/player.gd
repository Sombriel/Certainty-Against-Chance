extends CharacterBody2D

signal update_health(health: int)
signal update_chips(chips: int)
signal player_death
signal parried_boss

@export var hurtbox: Area2D
@export var bullet: PackedScene
@export var dash_timer: Timer
@export var dash_again_timer: Timer

var SPEED = 300.0
const JUMP_VELOCITY = -500.0
var DASH_SPEED: float = 900.0

var health: int = 100:
	set(new_health):
		update_health.emit(new_health)
		prints(health)
		health = new_health
var chips: int = 0:
	set(new_chips):
		update_chips.emit(new_chips)
		chips = new_chips
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: float = 1.0
var can_parry: bool = false
var is_parrying: bool = false
var is_dead: bool = false
var lock_movement: bool = false

func _ready() -> void:
	update_chips.emit(chips)

func _physics_process(delta: float) -> void:
	if is_dead or lock_movement:
		return
	
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if is_on_floor():
			can_parry = false

		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$Jump.pitch_scale = randf_range(0.7, 1.0)
			$Jump.play()
		
		#aka parry
		if Input.is_action_just_pressed("Jump") and not is_on_floor() and can_parry:
			chips = clampi(chips - 100, -50, 100)
			parried_boss.emit()
			can_parry = false
			is_parrying = true
			print("PARRY!")
			$Parry.play()
			_parry_pause_effect()
		
		var direction: float = Input.get_axis("Left", "Right")

		if direction != 0:
			velocity.x = direction * SPEED
			dash_direction = direction
			$Animations.flip_h = direction < 0  
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("Dash") and can_dash:
			_dash()

	## Animations
	if is_dashing:
		$Animations.play("dash")
	elif is_parrying:
		$Animations.play("parry")
	elif not is_on_floor():
		$Animations.play("jumping")
	elif velocity.x != 0:
		$Animations.play("running")
	else:
		$Animations.play("idle")
	
	move_and_slide()

func _dash() -> void:
	is_dashing = true
	can_dash = false
	hurtbox.set_deferred("monitoring", false)
	dash_timer.start()
	dash_again_timer.start()
	$Dash.play()

func _parry_pause_effect() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.2, true).timeout
	get_tree().paused = false

func end_of_dash() -> void:
	hurtbox.set_deferred("monitoring", true)
	is_dashing = false
	velocity.x = 0

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

func take_damage(area: Area2D) -> void:
	if area.is_in_group("parryable") and chips == 100:
		can_parry = true
		if area.has_signal("start_battle") and chips == 100:
			area.start_battle.emit()
			print_debug("STARTED")
		return
	
	if area.is_in_group("dice") or area.is_in_group("cards"):
		health = clampi(health - area.damage, 0, 200)
		area.queue_free()
		$Damage.pitch_scale = randf_range(0.7, 1.0)
		$Damage.play()
	
	if health <= 0:
		die()
	
	prints(health)

func add_chips(payout: int) -> void:
	chips = clamp(chips + payout, -50, 100)

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	$Animations.play("death")
	$Gun.hide()
	player_death.emit()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _rolled_positive_effect() -> void:
	$Gun.add_positive_stack()
	health = clampi(health + 20, 0, 200)
	SPEED = clamp(SPEED + 150, 150, 400)
	DASH_SPEED = clampf(DASH_SPEED + 200, 700, 1000)

func _rolled_negative_effect() -> void:
	$Gun.add_negative_stack()
	chips = clampi(chips - 75, -50, 100)
	SPEED = clampi(SPEED - 100, 150, 400)
	DASH_SPEED = clampf(DASH_SPEED - 100, 700, 1000)


func _on_animations_animation_finished() -> void:
	is_parrying = false

func _on_boss_death() -> void:
	lock_movement = true
	$Gun.can_fire = false
	
