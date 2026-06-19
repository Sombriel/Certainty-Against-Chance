extends CharacterBody2D

@export var hurtbox: Area2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.6

var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var facing_direction := 1.0  # remembers last direction for dashing with no input held

func _physics_process(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		velocity.x = facing_direction * DASH_SPEED
		velocity.y = 0  # ignore gravity during the dash
		if dash_timer <= 0.0:
			is_dashing = false
			hurtbox.set_deferred("disabled", false)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
			facing_direction = sign(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("Dash") and dash_cooldown_timer <= 0.0:
			is_dashing = true
			dash_timer = DASH_DURATION
			dash_cooldown_timer = DASH_COOLDOWN
			hurtbox.set_deferred("disabled", true)

	move_and_slide()
