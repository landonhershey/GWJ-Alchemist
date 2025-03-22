extends Node

class_name Hand

# Properties
var infection: float = 0.0 # Infection level (0.0 to 1.0)
var infection_rate: float = 0.0 # Rate at which infection increases
var productivity: float = 1.0 # Productivity level (1.0 is base productivity)
var max_infection = 1.0

signal infection_complete

func create(infection_p : float, infection_rate_p : float, productivity_p : float) -> void:
	# Initialize any necessary variables or states here
	infection = infection_p
	infection_rate = infection_rate_p
	productivity = productivity_p
	

func get_infection() -> float:
	return infection

# Method to calculate productivity based on infection level
func get_productivity() -> float:
	return productivity # will cause bug

func get_infection_rate() -> float:
	return infection_rate  


func set_infection(new_infection: float) -> void:
	infection = clamp(new_infection, 0.0, max_infection) # Ensure infection stays within bounds

func reduce_infection(amount: float) -> void:
	infection = max(0.0, infection - amount)

func set_infection_rate(new_infection_rate: float) -> void:
	infection_rate = new_infection_rate

func set_productivity(new_productivity: float) -> void:
	print("Setting productivity to: ", new_productivity)
	productivity = new_productivity


func end_turn() -> void:
	infection += infection_rate
	if infection >= max_infection:
		infection = max_infection
		productivity = 0.0
		emit_signal("infection_complete")
