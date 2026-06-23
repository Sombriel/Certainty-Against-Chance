extends Node2D

signal hit(damage: int)

@export var CardAttack: PackedScene
@export var DiceAttack: PackedScene

@onready var attacks: Array = [$CardAttack, $DiceAttack]

var health: int = 5000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.emit(health)

func choose_attack() -> void:
	attacks.pick_random().start()

func bullet_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		$HitFlashAnim.play("hit")
		area.queue_free()
	
	hit.emit(health)

func attack_chance() -> void:
	var attack_roll: float = randf()
	
	if attack_roll > 0.5:
		choose_attack()
		print("Rolled ATTACK")
	else:
		print("Rolled PASSIVE")
		return
