extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)

func update_bosshp(health: int) -> void:
	$BossHP.text = str(health)
