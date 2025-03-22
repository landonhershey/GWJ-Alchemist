extends Potion
class_name Adrenaline
"""
Adrenaline Potion

Boosts productivity for 2 turns
"""
func _init() -> void:
    effect_duration = 2
    productivity_multiplier = 1.0

    infection_multiplier = 1.0
    infection_reduction = 0.0
    productivity_addition = 5.0

func apply_effect(player: Player) -> void:
    print("Applying Adrenaline effect")
    super.apply_effect(player)

func end_turn(player: Player) -> void:
    super.end_turn(player)