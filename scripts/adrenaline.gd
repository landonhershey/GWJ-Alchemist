extends Potion
class_name Adrenaline
"""
Adrenaline Potion

Boosts productivity for 2 turns
"""
func _init() -> void:
	effect_duration = 3
	productivity_multiplier = 1.0

	infection_multiplier = 1.0
	infection_reduction = 0.0
	productivity_addition = 5.0

	message = "You feel a surge of energy!"
	decay_message = "The adrenaline wears off. You feel tired."

func apply_effect(player: Player) -> void:
	print("Applying Adrenaline effect")
	super.apply_effect(player)

func end_turn(player: Player) -> void:
	super.end_turn(player)