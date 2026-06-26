extends Area2D

var velocity = Vector2.ZERO
var damage: int = 1

func _ready() -> void:
	add_to_group("cards")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
