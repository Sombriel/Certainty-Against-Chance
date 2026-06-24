extends Control


func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)


func update_boss_hp(health: int) -> void:
	$BossHP.text = str(health)
	$BossHPBar.value = health


func _roll_insta_win() -> void:
	get_tree().paused = true
	$TempWinScreen.show()
	

func _update_health(health: int) -> void:
	$PlayerHealth.value = health
