extends Node2D

@export var bullet: PackedScene
@export var cooldown: Timer

@onready var bullet_spawnpoint: Marker2D = $BulletSpawnPoint

var can_fire: bool = true
var positive_effect: bool = false
var negative_effect: bool = false

var effect_stack: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

	if Input.is_action_pressed("Shoot") and can_fire:
		can_fire = false
		cooldown.start()
		var bullet_instance = bullet.instantiate()
		bullet_instance.damage += effect_stack
		get_tree().root.add_child(bullet_instance)
		
		bullet_instance.global_position = bullet_spawnpoint.global_position
		bullet_instance.rotation = rotation
		$Animation.play("default")
	else:
		$Animation.play("idle")

func add_positive_stack() -> void:
	effect_stack = clampi(effect_stack + 10, 0, 30)

func add_negative_stack() -> void:
	effect_stack = clampi(effect_stack - 10, 0, 30)

func _on_cooldown_timeout() -> void:
	can_fire = true
