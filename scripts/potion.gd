class_name Potion
"""
Base class for Potions
"""
# Properties
var effect_duration: int
var productivity_multiplier: float = 1.0
var infection_reduction: float = 0.0
var infection_multiplier: float = 1.0

signal potion_effect_ended

var player : Player

func _init() -> void:
    
    # Initialize any necessary variables or states here
    effect_duration = 0
    productivity_multiplier = 1.0
    infection_reduction = 0.0
    infection_multiplier = 1.0

func apply_effect() -> void:
    # Apply the potion effects here
    pass

func end_turn() -> void:
    # Apply the potion effects for the turn
    effect_duration -= 1
    if effect_duration <= 0:
        # Reset effects after duration
        effect_duration = 0
        emit_signal("potion_effect_ended")