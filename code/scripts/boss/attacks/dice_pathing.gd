extends PathFollow2D

@export var speed: float = randf_range(0.06, 0.1)

func _process(delta: float) -> void:
	progress_ratio += speed * delta
