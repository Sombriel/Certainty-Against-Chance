extends Node2D

@export var dice: PackedScene
@onready var spawnpoints: Array = [$SpawnPointLeft, $SpawnPointRight]

func start() -> void:
	var dice_scene: Node = dice.instantiate()
	add_child(dice_scene)
	dice_scene.position = spawnpoints.pick_random().position
	
	$AttackDuration.start()

func _on_attack_duration_timeout() -> void:
	pass #stop the attack here
