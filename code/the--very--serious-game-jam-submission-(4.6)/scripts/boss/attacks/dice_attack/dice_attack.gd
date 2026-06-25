extends Node2D

@export var dice: PackedScene
@onready var paths: Array = [$PathONE/PathFollow2D, $PathTWO/PathFollow2D, $PathTHREE/PathFollow2D]

@export var dice_count: int = randi_range(1, 4) 

func start() -> void:
	var available_paths: Array = paths.duplicate()
	available_paths.shuffle()

	for i in range(min(dice_count, available_paths.size())):
		var chosen_path: PathFollow2D = available_paths[i]
		chosen_path.progress_ratio = 0.0 

		var dice_scene: Area2D = dice.instantiate()
		chosen_path.add_child(dice_scene)
