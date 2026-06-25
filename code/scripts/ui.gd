extends Control

func _ready() -> void:
	$TempWinScreen.hide()
	$BossHPBar.hide()
	$PlayerHealth.hide()

func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)

func update_boss_hp(health: int) -> void:
	$BossHPBar.value = health

func _roll_insta_win() -> void:
	get_tree().paused = true
	$TempWinScreen.show()
	

func _update_health(health: int) -> void:
	$PlayerHealth.value = health

func _on_start_battle() -> void:
	$BossHPBar.show()
	$PlayerHealth.show()
	fade_out_bg()

func fade_out_bg() -> void:
	var tween = create_tween()
	tween.tween_property($Darken, "color:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	$Darken.queue_free()
