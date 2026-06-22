extends Node2D

@export var ten_chip: PackedScene
@export var twenty_chip: PackedScene
@export var fifty_chip: PackedScene

@onready var chips: Array[PackedScene] = [ten_chip, twenty_chip, fifty_chip]
@onready var paths: Array[PathFollow2D] = [$LeftPath/PathFollow2D, $RightPath/PathFollow2D]

func spawn_chip() -> void:
	var spawned_chip: Node = chips.pick_random().instantiate()
	var chosen_path: PathFollow2D = paths.pick_random()
	chosen_path.add_child(spawned_chip)
