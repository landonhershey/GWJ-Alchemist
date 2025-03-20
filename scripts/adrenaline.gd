extends Potion
class_name Adrenaline
"""
Adrenaline Potion

Boosts productivity for 2 turns
"""
func _init() -> void:
    effect_duration = 2
    productivity_multiplier = 1.5

    infection_multiplier = 1.0
    infection_reduction = 0.0

func end_turn() -> void:
    super.end_turn()