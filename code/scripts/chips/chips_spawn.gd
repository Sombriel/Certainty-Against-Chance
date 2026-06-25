extends Node2D

@export var ten_chip: PackedScene
@export var twenty_chip: PackedScene
@export var fifty_chip: PackedScene

@onready var chips: Array[PackedScene] = [ten_chip, twenty_chip, fifty_chip]
@onready var left_spawnpoints: Array[Marker2D] = [$LeftSpawn1, $LeftSpawn2]
@onready var right_spawnpoints: Array[Marker2D] = [$RightSpawn1, $RightSpawn2]

func _on_start_battle_() -> void:
	$ChipSpawner.start()

func spawn_chip() -> void:
	var spawned_chip: Node = chips.pick_random().instantiate()
	
	var spawn_left: bool = randi() % 2 == 0
	var spawnpoint: Marker2D = (left_spawnpoints if spawn_left else right_spawnpoints).pick_random()
	
	spawned_chip.direction = 1 if spawn_left else -1
	
	add_child(spawned_chip)
	
	spawned_chip.global_position = spawnpoint.global_position

func _on_boss_death() -> void:
	$ChipSpawner.stop()
