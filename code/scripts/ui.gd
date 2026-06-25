extends Control

func _ready() -> void:
	$TempWinScreen.hide()
	$BossHPBar.hide()

func update_chip_count(chip_amount: int) -> void:
	$Money.text = str(chip_amount)

func update_boss_hp(health: int) -> void:
	$BossHPBar.value = health

func _roll_insta_win() -> void:
	get_tree().paused = true
	$WinScreen/Win.text += str(" You rolled an insta-win :)")

func _roll_insta_loss() -> void:
	$LoseScreen.show()
	$LoseScreen/Lose.text += str(" You rolled an instant loss :(")

func _update_health(health: int) -> void:
	if health == 100:
		$CertaintyHP.frame = 10
	elif health >= 90:
		$CertaintyHP.frame = 9
	elif health >= 80:
		$CertaintyHP.frame = 8
	elif health >= 70:
		$CertaintyHP.frame = 7
	elif health >= 60:
		$CertaintyHP.frame = 6
	elif health >= 50:
		$CertaintyHP.frame = 5
	elif health >= 40:
		$CertaintyHP.frame = 4
	elif health >= 30:
		$CertaintyHP.frame = 3
	elif health >= 20:
		$CertaintyHP.frame = 2
	elif health >= 5:
		$CertaintyHP.frame = 1
	else:
		$CertaintyHP.frame = 0

func _on_start_battle() -> void:
	$BossHPBar.show()
	$CertaintyHP.play("default")
	fade_out_bg()

func fade_out_bg() -> void:
	var tween = create_tween()
	tween.tween_property($Darken, "color:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	$Darken.queue_free()

func _input(event):
	if event.is_action_pressed("Pause"):
		get_tree().paused = !get_tree().paused
	
		if get_tree().paused:
			$PauseMenu.show()
			$PauseMenu/CanvasLayer.show()
		else:
			$PauseMenu.hide()
			$PauseMenu/CanvasLayer.hide()


func _on_boss_death() -> void:
	$WinScreen.show()

func _on_certainty_death() -> void:
	$LoseScreen.show()
