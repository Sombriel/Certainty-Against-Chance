extends Control


func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)


func update_boss_hp(damage: int) -> void:
	$BossHP.text = str(damage)
