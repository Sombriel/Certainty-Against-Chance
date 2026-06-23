extends PathFollow2D

@export var speed = 0.1

var idle = true
var direction = 1

func _process(delta):
	var randomness = randf()
	if randomness < 0.01:
		if idle:
			direction = -1 if randi() % 2 == 0 else 1 
		else:
			direction = 0
		idle = not idle
	progress_ratio += delta * speed * direction
	
