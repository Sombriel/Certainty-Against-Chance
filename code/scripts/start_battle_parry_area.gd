extends Area2D

signal start_battle

func _cleanup_start_parry_box() -> void:
	queue_free()
