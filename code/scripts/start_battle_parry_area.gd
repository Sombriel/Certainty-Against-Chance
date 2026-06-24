extends Area2D

signal start_battle

func _on_tutorial_finished() -> void:
	monitorable = true

func start_casino_battle() -> void:
	start_battle.emit()
