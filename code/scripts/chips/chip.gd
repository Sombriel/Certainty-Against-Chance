class_name Chip extends Area2D

@export var value: int = 10
@export var texture: Texture2D
@export var health: int = 10

@export_group("Wander")
@export var speed: float = 110.0
@export var wander_amplitude: float = 80.0   # How far it drifts up/down (pixels/sec)
@export var wander_frequency: float = 1.8    # How often it changes vertical direction

## Set by the spawner before the chip enters the scene — 1 = right, -1 = left
var direction: int = 0
var _time: float = 0.0
var _phase: float = 0.0   # Random per-chip offset so chips don't wander in sync
var is_dead: bool = false

func _ready() -> void:
	_phase = randf() * TAU

func _process(delta: float) -> void:
	if direction == 0 or is_dead:
		return
 
	_time += delta
 
	var wave: float = sin(_time * wander_frequency + _phase) \
					+ sin(_time * wander_frequency * 1.6 + _phase * 0.7) * 0.35
 
	position += Vector2(direction * speed, wave * wander_amplitude) * delta
 
func exited_screen() -> void:
	queue_free()

func take_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		area.queue_free()
	
	if health <= 0:
		is_dead = true
		$Death.play()
		$CollisionShape2D.set_deferred("disabled", true)
		get_tree().get_first_node_in_group("player").add_chips(value)
		$Animations.play("death")
		await $Animations.animation_finished
		queue_free()
