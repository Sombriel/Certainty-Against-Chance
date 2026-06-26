extends Node2D

#damage update for UI
signal hit(damage: int)
signal death()

#player effects when player rolls the boss
signal positive_effect
signal negative_effect
signal insta_win
signal insta_loss
signal increase_patrol_speed

@onready var attacks: Array = [$CardAttack, $DiceAttack]

var health: int = 15000
var _speed_thresholds: Array[float] = [0.75, 0.50, 0.25]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.emit(health)
	$AnimatedSprite2D.play("patrol")
	$ParryArea.monitorable = false

func choose_attack() -> void:
	attacks.pick_random().start()

func bullet_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		$HitFlashAnim.play("hit")
		flash_hit()
		area.queue_free()
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$DeathSound.play()
		death.emit()

	hit.emit(health)

func attack_chance() -> void:
	var attack_roll: float = randf()
	
	if attack_roll > 0.5:
		choose_attack()
		print("Rolled ATTACK")
	else:
		print("Rolled PASSIVE")
		return

func _on_parry_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.can_parry = true

func _on_certainty_parried_boss() -> void:
	var effect: StringName = RandLogic.roll_effect()
	match effect:
		"POSITIVE":
			positive_effect.emit()
			$PlayerBuffEffect.play()
		"NEGATIVE":
			negative_effect.emit()
			$PlayerDebuffEffect.play()
		"WIN":
			insta_win.emit()
		"LOSE":
			insta_loss.emit()
	print(effect)

func _on_start_battle() -> void:
	$Hurtbox.set_deferred("disabled", false)
	$AnimatedSprite2D.play("patrol")
	
func _on_tutorial_finished() -> void:
	$AnimatedSprite2D.play("roll")
	z_index += 1

func flash_hit() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("hit_flash_on", true)
	await get_tree().create_timer(0.1, false).timeout
	$AnimatedSprite2D.material.set_shader_parameter("hit_flash_on", false)

func _check_speed_thresholds() -> void:
	if _speed_thresholds.is_empty():
		return
	if float(health) / 15000.0 <= _speed_thresholds[0]:
		increase_patrol_speed.emit()
		_speed_thresholds.remove_at(0)
		print_debug("PATROL SPEED INCREASED")
