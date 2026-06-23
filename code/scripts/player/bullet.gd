extends Area2D

const SPEED: int = 1000

var damage: int = 10

func _ready() -> void:
	add_to_group("bullets")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

#for the positive and negative effects
func increase_bullet_damage() -> void:
	damage = clamp(damage + 10, 5, 50)

func decrease_bullet_damage() -> void:
	damage = clamp(damage - 10, 5, 50)
