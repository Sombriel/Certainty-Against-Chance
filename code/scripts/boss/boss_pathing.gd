extends PathFollow2D

signal patrol_attack_chance

@export var speed = 0.2

## this is set to true to start the battle after tutorial
var can_patrol: bool = false
var patrol_pause: bool = false
var patrol_direction: float = 1.0
var patrol_pause_markers: Array[float] = [0.0, 0.5, 1.0]
var _last_pause_marker: float = -1.0

func _process(delta):
	if not can_patrol:
		return
	
	if not patrol_pause:
		progress_ratio += delta * speed * patrol_direction
		
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
		var sprite = $Boss/AnimatedSprite2D
		sprite.play("roll")
		await sprite.animation_finished
		var last_frame = sprite.sprite_frames.get_frame_count("roll") - 1
		sprite.frame = last_frame
		sprite.pause() 
		$Boss/ParryArea.monitorable = true

func _on_boss_pauses_timeout() -> void:
	patrol_pause = false
	$Boss/AnimatedSprite2D.play("roll", true)

	await $Boss/AnimatedSprite2D.animation_finished
	patrol_pause = false # Only resume movement AFTER the reverse animation finishes
	$Boss/AnimatedSprite2D.play("patrol")

func _on_start_battle() -> void:
	can_patrol = true

func _on_boss_death() -> void:
	can_patrol = false

func increase_patrol_speed() -> void:
	speed += 0.001
