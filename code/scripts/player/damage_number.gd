extends Node2D


func spawn(value: int, boss_position: Vector2) -> void:
	$Label.text = str(value)
	$Label.add_theme_font_override("font", load("uid://bcw4tlrn5sqgv"))
	global_position = boss_position
	
	var tween := create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.8)
	tween.parallel().tween_property($Label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)
