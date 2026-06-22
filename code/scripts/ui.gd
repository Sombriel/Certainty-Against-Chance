extends Control


func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)
