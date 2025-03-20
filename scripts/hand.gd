class_name Hand

# Properties
var infection: float = 0.0 # Infection level (0.0 to 1.0)
var infection_rate: float = 0.01 # Rate at which infection increases
var productivity: float = 1.0 # Productivity level (1.0 is base productivity)

signal infection_complete

func _init(infection_p : float, infection_rate_p : float, productivity_p : float) -> void:
    # Initialize any necessary variables or states here
    infection = infection_p
    infection_rate = infection_rate_p
    productivity = productivity_p
    

func get_infection() -> float:
    return infection

# Method to calculate productivity based on infection level
func get_productivity() -> float:
    return 1.0 - infection # Productivity decreases as infection increases

func get_infection_rate() -> float:
    return infection_rate  


func set_infection(new_infection: float) -> void:
    infection = clamp(new_infection, 0.0, 1.0) # Ensure infection stays within bounds

func reduce_infection(amount: float) -> void:
    infection = max(0.0, infection - amount)

func set_infection_rate(new_infection_rate: float) -> void:
    infection_rate = new_infection_rate

func set_productivity(new_productivity: float) -> void:
    productivity = new_productivity


func end_turn() -> void:
    infection += infection_rate
    productivity = 1.0 - infection
    if infection >= 1.0:
        infection = 1.0
        productivity = 0.0
        emit_signal("infection_complete")

