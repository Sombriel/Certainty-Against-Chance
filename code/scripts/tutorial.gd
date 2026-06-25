extends Control

#holy fuck this is awful and ass

signal tutorial_finished
signal cleanup_start_parry_box
signal chips_spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_in_text()
	
	await get_tree().create_timer(8.0).timeout
	
	fade_out_text()
	
	await get_tree().create_timer(3.0).timeout
	$TextDisplay.text = "Press SHIFT to DASH you are INVULNERABLE throughout this dash"
	fade_in_text()
	
	await get_tree().create_timer(8.0).timeout
	fade_out_text()
	
	await get_tree().create_timer(3.0).timeout
	$TextDisplay.text = "Press LEFT CLICK to SHOOT where your cursor is"
	fade_in_text()
	await get_tree().create_timer(8.0).timeout
	fade_out_text()
	await get_tree().create_timer(3.0).timeout
	$TextDisplay.text = "Shooting CHIPS grants you playing chips to SPIN! Grab 100 chips!"
	chips_spawn.emit()
	fade_in_text()
	await get_tree().create_timer(8.0).timeout
	fade_out_text()
	
	await get_tree().create_timer(3.0).timeout
	$TextDisplay.text = "Pressing SPACEBAR while in the air allows you to SPIN"
	fade_in_text()
	
	await get_tree().create_timer(8.0).timeout
	fade_out_text()
	await get_tree().create_timer(3.0).timeout
	$TextDisplay.text = "Try your chances now...Certainty"
	fade_in_text()
	
	tutorial_finished.emit()

func fade_in_text() -> void:
	var tween = create_tween()
	tween.tween_property($TextDisplay, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR)

func fade_out_text() -> void:
	var tween = create_tween()
	tween.tween_property($TextDisplay, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR)

func _on_start_battle() -> void:
	cleanup_start_parry_box.emit()
	
