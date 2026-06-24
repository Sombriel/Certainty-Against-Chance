extends CharacterBody2D

signal update_chips(chips: int)
signal player_death
signal parried_boss

@export var hurtbox: Area2D
@export var bullet: PackedScene
@export var dash_timer: Timer
@export var dash_again_timer: Timer

var SPEED = 300.0
const JUMP_VELOCITY = -500.0
const DASH_SPEED: float = 900.0

var health: int = 100
var chips: int = 0
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: float = 1.0
var can_parry: bool = false
var is_parrying: bool = false
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if is_dead:
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
		
		#aka parry
		if Input.is_action_just_pressed("Jump") and not is_on_floor() and can_parry:
			parried_boss.emit()
			can_parry = false
			is_parrying = true
			print("PARRY!")
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
	if area.is_in_group("parryable"):
		can_parry = true
		return
	
	if area.is_in_group("dice") or area.is_in_group("cards"):
		health = clamp(health - area.damage, 0, 200)
		area.queue_free()	
	
		if health <= 0:
			die()
	
	prints(health)

func add_chips(payout: int) -> void:
	chips += payout
	update_chips.emit(chips)
	#print(chips)

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	$Animations.play("death")
	$Gun.hide()
	player_death.emit()

func _rolled_positive_effect() -> void:
	$Gun.add_positive_stack()
	clamp(health + 10, 0, 200)
	SPEED = clamp(SPEED + 150, 200, 400)

func _rolled_negative_effect() -> void:
	$Gun.add_negative_stack()
	SPEED = clamp(SPEED - 100, 200, 400)


func _on_animations_animation_finished() -> void:
	is_parrying = false
