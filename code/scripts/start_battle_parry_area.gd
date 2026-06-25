extends Area2D

signal start_battle

func start_casino_battle() -> void:
	start_battle.emit()

func _cleanup_start_parry_box() -> void:
	queue_free()

func _on_tutorial_finished() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
