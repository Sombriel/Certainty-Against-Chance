extends CharacterBody2D

@export var hurtbox: Area2D
@export var bullet: PackedScene
@export var bullet_spawn: Marker2D   # child node placed in front of the character (e.g. at gun height, offset to the right)
@export var bullet_speed := 800.0
@export var fire_rate := 0.2         # seconds between shots

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.6

var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer : float = 0.0
var facing_direction : float = 1.0  # remembers last direction for dashing with no input held
var fire_cooldown_timer := 0.0

func _physics_process(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta
	if fire_cooldown_timer > 0.0:
		fire_cooldown_timer -= delta

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
			_update_facing()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("Dash") and dash_cooldown_timer <= 0.0:
			is_dashing = true
			dash_timer = DASH_DURATION
			dash_cooldown_timer = DASH_COOLDOWN
			hurtbox.set_deferred("disabled", true)

		if Input.is_action_pressed("Shoot") and fire_cooldown_timer <= 0.0:
			_shoot()

	move_and_slide()


func _update_facing() -> void:
	# Keep the spawn point mirrored to whichever side the character is facing.
	bullet_spawn.position.x = abs(bullet_spawn.position.x) * facing_direction
	# If your sprite isn't already flipped elsewhere (e.g. via AnimatedSprite2D.flip_h),
	# uncomment the line below to flip the whole body instead:
	# scale.x = facing_direction


func _shoot() -> void:
	if bullet == null or bullet_spawn == null:
		return

	fire_cooldown_timer = fire_rate

	var b: Node2D = bullet.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = bullet_spawn.global_position

	# Pass the firing direction to the bullet in whichever way its script expects.
	# This checks the common patterns so it works regardless of how your bullet is set up.
	if b.has_method("set_direction"):
		b.set_direction(facing_direction)
	elif "direction" in b:
		b.direction = Vector2(facing_direction, 0)
	elif "velocity" in b:
		b.velocity = Vector2(facing_direction * bullet_speed, 0)

	# Flip the bullet's sprite to match the facing direction, if applicable.
	if "scale" in b:
		b.scale.x = abs(b.scale.x) * facing_direction
