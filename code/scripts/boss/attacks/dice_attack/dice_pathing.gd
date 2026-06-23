extends PathFollow2D

var speed: float

func _ready() -> void:
	loop = false
	# Randomized here per instance — export default only runs once at load time
	speed = randf_range(0.06, 0.1)

func _process(delta: float) -> void:
	progress_ratio += speed * delta

	if progress_ratio >= 1.0:
		# queue_free on self cleans up the follower AND the die child with it
		queue_free()
