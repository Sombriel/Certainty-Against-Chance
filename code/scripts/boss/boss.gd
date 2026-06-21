extends Node2D

@export var card_attack: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var attack: Node = card_attack.instantiate()
	attack.start()
	add_child(attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
