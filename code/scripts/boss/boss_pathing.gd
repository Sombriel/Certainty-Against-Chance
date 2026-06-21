extends PathFollow2D

@export var speed = 0.1

func _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
