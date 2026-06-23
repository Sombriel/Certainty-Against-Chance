extends PathFollow2D

signal patrol_attack_chance

@export var speed = 0.2

var patrol_pause: bool = false
var patrol_direction: float = 1.0
var patrol_pause_markers: Array[float] = [0.0, 0.5, 1.0]
var _last_pause_marker: float = -1.0

var idle = true
var direction = 1

func _process(delta):
<<<<<<< HEAD
	var randomness = randf()
	if randomness < 0.01:
		if idle:
			direction = -1 if randi() % 2 == 0 else 1 
		else:
			direction = 0
		idle = not idle
	progress_ratio += delta * speed * direction
	
=======
	if not patrol_pause:
		progress_ratio += delta * speed * patrol_direction

		# Flip direction at each end and clamp so it doesn't overshoot
		if progress_ratio >= 1.0:
			patrol_direction = -1.0
		elif progress_ratio <= 0.0:
			patrol_direction = 1.0
	
	var snapped_ratio: float = snapped(progress_ratio, 0.01)
	
	if not patrol_pause and patrol_pause_markers.has(snapped_ratio) and snapped_ratio != _last_pause_marker:
		patrol_pause = true
		_last_pause_marker = snapped_ratio
		patrol_attack_chance.emit()
		$BossPauses.start()
		##add an attack here
	
	#print(snapped(progress_ratio, 0.01))

func _on_boss_pauses_timeout() -> void:
	patrol_pause = false
>>>>>>> 737ea970dda43bd78ac70332999b50239b7837cd
