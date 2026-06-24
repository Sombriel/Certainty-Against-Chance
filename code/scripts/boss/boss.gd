extends Node2D

#damage update for UI
signal hit(damage: int)
signal death()

#player effects when player rolls the boss
signal positive_effect
signal negative_effect
signal insta_win
signal insta_loss

@export var CardAttack: PackedScene
@export var DiceAttack: PackedScene

@onready var attacks: Array = [$CardAttack, $DiceAttack]

var health: int = 8000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.emit(health)
	$AnimatedSprite2D.play("default")

func choose_attack() -> void:
	attacks.pick_random().start()

func bullet_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		$HitFlashAnim.play("hit")
		area.queue_free()
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
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
	$AnimatedSprite2D.play("roll")
	var effect: StringName = RandLogic.roll_effect()
	match effect:
		"POSITIVE":
			positive_effect.emit()
		"NEGATIVE":
			negative_effect.emit()
		"WIN":
			insta_win.emit()
		"LOSE":
			insta_loss.emit()
	print(effect)
