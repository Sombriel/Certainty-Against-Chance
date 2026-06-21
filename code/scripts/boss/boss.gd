extends Node2D

@onready var attacks: Array = [$CardAttack, $DiceAttack]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_attack() -> void:
	attacks.pick_random().start()
