extends CharacterBody2D

signal update_chips(chips: int)

@export var hurtbox: Area2D
@export var bullet: PackedScene
@export var dash_timer: Timer
@export var dash_again_timer: Timer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED: float = 900.0

var health: int = 100
var chips: int = 0
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: float = 1.0

func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction: float = Input.get_axis("Left", "Right")
		
		if direction != 0:
			velocity.x = direction * SPEED
			dash_direction = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("Dash") and can_dash:
			_dash()
	
	## Animations
	if velocity == Vector2.ZERO:
		$Animations.play("idle")
	
	move_and_slide()

func _dash() -> void:
	is_dashing = true
	can_dash = false
	hurtbox.set_deferred("monitoring", false)
	dash_timer.start()
	dash_again_timer.start()

func end_of_dash() -> void:
	hurtbox.set_deferred("monitoring", true)
	is_dashing = false
	velocity.x = 0

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

func take_damage(area: Area2D) -> void:
	if area.is_in_group("cards"):
		health -= area.damage
		area.queue_free()
	
	if area.is_in_group("dice"):
		health -= area.damage
	
	prints(health)

func add_chips(payout: int) -> void:
	chips += payout
	update_chips.emit(chips)
	#print(chips)
