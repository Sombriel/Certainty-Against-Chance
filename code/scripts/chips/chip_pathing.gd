extends PathFollow2D

const SPEED: float = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += delta * SPEED
