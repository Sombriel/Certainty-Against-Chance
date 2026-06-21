extends Node2D

@export var card_attack: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CardAttack.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
