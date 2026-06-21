extends Node2D

@export var attack_card: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start() -> void:
	$AttackDuration.start()
	$CardTimer.start()

func _on_card_timer_timeout() -> void:
	var card: Node2D = attack_card.instantiate()
	var card_spawn_location: PathFollow2D = $CardPath/CardPathSpawnLocation
	card_spawn_location.progress_ratio = randf()

	add_child(card)
	card.global_position = card_spawn_location.global_position
	card.velocity = Vector2(0.0, randf_range(150.0, 250.0))


func _on_attack_duration_timeout() -> void:
	$CardTimer.stop()
