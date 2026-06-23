extends Node2D

@export var dice: PackedScene

# Reference Path2D nodes directly — PathFollow2D nodes are created dynamically now
@onready var paths: Array[Path2D] = [$PathONE, $PathTWO, $PathTHREE]


func start() -> void:
	var dice_count: int = randi_range(1, paths.size())
	var available_paths: Array = paths.duplicate()
	available_paths.shuffle()

	for i in range(dice_count):
		var path: Path2D = available_paths[i]

		# Fresh PathFollow2D per die — fully independent, no shared state
		var follower: PathFollow2D = PathFollow2D.new()
		follower.set_script(load("uid://chi6orwmcjiln"))
		path.add_child(follower)

		var die: Area2D = dice.instantiate()
		follower.add_child(die)
