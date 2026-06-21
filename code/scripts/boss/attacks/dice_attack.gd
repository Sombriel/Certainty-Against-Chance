extends Node2D

@export var dice: PackedScene
@onready var paths: Array = [$PathONE/PathFollow2D, $PathTWO/PathFollow2D, $PathTHREE/PathFollow2D]

func start() -> void:
	var dice_scene: Area2D = dice.instantiate()
	var chosen_path: PathFollow2D = paths.pick_random()
	chosen_path.add_child(dice_scene)

	$AttackDuration.start()
