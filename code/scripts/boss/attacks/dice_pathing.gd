extends PathFollow2D

@export var speed: float = randf_range(0.06, 0.1)
signal end

func _ready() -> void:
	loop = false  # so progress_ratio clamps at 1.0 instead of wrapping back to 0

func _process(delta: float) -> void:
	progress_ratio += speed * delta

	if progress_ratio >= 1.0:
		end.emit()
		set_process(false)
		for child in get_children():
			child.queue_free()
