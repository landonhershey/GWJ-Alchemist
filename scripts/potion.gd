class_name Potion
"""
Base class for Potions
"""
# Properties
var effect_duration: int
var productivity_multiplier: float = 1.0
var infection_reduction: float = 0.0
var infection_multiplier: float = 1.0
var productivity_addition: float = 0.0

var message : String = "You feel strange..."
var decay_message: String = "The potion's effects wear off."

signal potion_effect_ended


func _init() -> void:
	
	# Initialize any necessary variables or states here
	effect_duration = 0
	productivity_multiplier = 1.0
	infection_reduction = 0.0
	infection_multiplier = 1.0
	productivity_addition = 0.0

func apply_effect(player: Player) -> void:
	# Apply the potion effects here
	player.left_hand.set_productivity(player.left_hand.get_productivity() * productivity_multiplier)
	player.right_hand.set_productivity(player.right_hand.get_productivity() * productivity_multiplier)
	player.left_hand.set_productivity(player.left_hand.get_productivity() + productivity_addition)
	player.right_hand.set_productivity(player.right_hand.get_productivity() + productivity_addition)


func remove_effect(player: Player) -> void:
	# Remove the potion effects here
	player.left_hand.set_productivity(player.left_hand.get_productivity() / productivity_multiplier)
	player.right_hand.set_productivity(player.right_hand.get_productivity() / productivity_multiplier)
	player.left_hand.set_productivity(player.left_hand.get_productivity() - productivity_addition)
	player.right_hand.set_productivity(player.right_hand.get_productivity() - productivity_addition)


func end_turn(player: Player) -> void:
	# Apply the potion effects for the turn
	effect_duration -= 1
	if effect_duration <= 0:    
		# Reset effects after duration
		effect_duration = 0
		remove_effect(player)
		emit_signal("potion_effect_ended")