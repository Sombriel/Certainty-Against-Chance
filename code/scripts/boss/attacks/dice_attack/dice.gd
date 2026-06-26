extends Area2D

var damage: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("dice")
	damage = randi_range(1, 2)
	$RandomDamageCooldown.start()

func randomize_damage() -> void:
	damage = randi_range(1, 6)
