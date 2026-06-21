extends Node2D

@onready var attacks: Array = [$CardAttack, $DiceAttack]

var health: int = 100000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_attack() -> void:
	attacks.pick_random().start()

func bullet_damage(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= area.damage
		$HitFlashAnim.play("hit")
		area.queue_free()
		#print(health)
