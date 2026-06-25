extends Node2D

signal hit(damge: int)

@onready var attacks: Array = [$CardAttack, $DiceAttack]

var health: int = 10000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_attack()
	hit.emit(health)

func choose_attack() -> void:
	attacks.pick_random().start()

func bullet_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		$HitFlashAnim.play("hit")
		area.queue_free()
	
	hit.emit(health)
