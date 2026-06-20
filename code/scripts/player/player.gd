extends CharacterBody2D

@export var hurtbox: Area2D
@export var bullet: PackedScene
@export var dash_timer: Timer
@export var dash_again_timer: Timer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED: float = 900.0

var is_dashing: bool = false
var can_dash: bool = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Dash") and can_dash:
		is_dashing = true
		can_dash = false
		hurtbox.set_deferred("monitoring", false)
		dash_timer.start()
		dash_again_timer.start()
	
	var direction := Input.get_axis("Left", "Right")
	if direction:
		if is_dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func end_of_dash() -> void:
	hurtbox.set_deferred("monitoring", true)
	is_dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
