extends Node2D

@export var dice: PackedScene
@onready var paths: Array = [$PathONE, $PathTWO, $PathTHREE]

func start() -> void:
	var dice_scene: Area2D = dice.instantiate()
	add_child(dice_scene)

	$AttackDuration.start()

func _on_attack_duration_timeout() -> void:
	pass #stop the attack here
