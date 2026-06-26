extends Control

func _ready() -> void:
	$TempWinScreen.hide()
	$BossHPBar.hide()

func update_chip_count(chip_amount: int) -> void:
	$Money.text = "Chips: " + str(chip_amount)

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
	$WinScreen/PlayAgain.show()

func _on_certainty_death() -> void:
	$LoseScreen.show()
	$LoseScreen/PlayAgain.show()

func _on_boss_positive_effect() -> void:
	$EffectIndicator.flip_v = false
	$EffectIndicator.show()
	
	# Track when this specific effect started
	var start_time = Time.get_ticks_msec() * 0.001
	var current_duration = 0.0
	
	# Loop manually for exactly 4 seconds
	while current_duration < 4.0:
		# Calculate your own absolute running time for the wave math
		var absolute_time = Time.get_ticks_msec() * 0.001
		var time_scaled = absolute_time * 5.0
		
		# Generate unique overlapping sine wave patterns
		var r = sin(time_scaled) * 0.5 + 0.5
		var g = sin(time_scaled + 2.0) * 0.5 + 0.5
		var b = sin(time_scaled + 4.0) * 0.5 + 0.5
		
		$EffectIndicator.modulate = Color(r, g, b, 1.0)
		
		# Wait 1 frame before running the loop again (simulates delta)
		await get_tree().process_frame
		
		# Update how long this loop has been running
		current_duration = (Time.get_ticks_msec() * 0.001) - start_time
		
	$EffectIndicator.hide()


func _on_boss_negative_effect() -> void:
	$EffectIndicator.flip_v = true
	$EffectIndicator.show()
	
	var start_time = Time.get_ticks_msec() * 0.001
	var current_duration = 0.0
	
	while current_duration < 4.0:
		var absolute_time = Time.get_ticks_msec() * 0.001
		var time_scaled = absolute_time * 15.0
		
		var trigger = round(sin(time_scaled) * 0.5 + 0.5)
		
		if trigger == 1:
			$EffectIndicator.modulate = Color(10, 0, 0, 1) # Note: Fixed 'modulate' to '$EffectIndicator.modulate'
		else:
			$EffectIndicator.modulate = Color.BLACK
			
		# Wait 1 frame before looping again
		await get_tree().process_frame
		
		current_duration = (Time.get_ticks_msec() * 0.001) - start_time
		
	$EffectIndicator.hide()
	
	await get_tree().create_timer(4.0).timeout
	$EffectIndicator.hide()


func _on_play_again_pressed() -> void:
	SkipTutorial.skip_tutorial = true
	get_tree().paused = false
	get_tree().reload_current_scene()
