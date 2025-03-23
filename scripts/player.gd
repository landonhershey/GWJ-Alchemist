extends Node
class_name Player

@onready var Game = get_parent()


var research_progress : float = 0.0
var max_research : float = 500.0
var research_rate : float = 1.0
var research_rate_multiplier : float = 1.0

var evil = 0.0
var evil_max = 100.0
var evil_rate = 0.0
var fingers = 5

var peak_productivity : float = 100.0

var potion_supply : Array[Potion] = []
var active_potions : Array[Potion] = []

@onready var left_hand : Hand = $LeftHand

@onready var right_hand : Hand = $RightHand


signal player_turn_over
signal researched(amount : float)
signal brewed_potion(potion : Potion)
signal consumed_potion(potion : Potion)
signal potion_effect_ended(potion : Potion)
signal cut_off_finger(remaining_fingers : int)

signal pray

signal invalid_action(message : String)

# ending signals


signal research_complete
signal infection_won
signal evil_won


func _ready() -> void:
	left_hand.create(0.1, 0.025, 1.0)
	right_hand.create(0.0, 0.0, 1.0)

	left_hand.connect("infection_complete", Callable(self, "_on_left_hand_infection_exceeded"))
	right_hand.connect("infection_complete", Callable(self, "_on_right_hand_infection_exceeded"))



func player_input() -> void:
	# Handle player input here
	# enable UI elements for player input
	player_turn_over.emit()

	pass



func knife() -> void:
	if fingers <= 0:
		invalid_action.emit("You have nothing left to sacrifice")
		return
	fingers -=1
	evil_rate += 1 * (1 + 5-fingers)
	evil += 20

	right_hand.set_productivity(right_hand.get_productivity() * 2.0)

	cut_off_finger.emit(fingers)
	player_turn_over.emit()
	return 

func holy_mantle() -> void:
	evil *= 0.6
	evil_rate *= 0.8
	pray.emit()
	player_turn_over.emit()



func end_turn() -> void:
	left_hand.end_turn()
	right_hand.end_turn()

	evil += evil_rate

	if evil >= evil_max:
		evil_won.emit() # Ending
	for potion in active_potions:
		potion.end_turn(self)
		if potion.effect_duration <= 0:
			potion_effect_ended.emit(potion)
			active_potions.erase(potion)
			

	print(get_stats())



func research():
	if research_progress >= max_research:
		research_complete.emit()
		return

	if research_progress < max_research:
		var research_increment = get_net_productivity()* research_rate
		research_progress += research_increment
		researched.emit(research_increment)


	player_turn_over.emit()



func get_net_productivity() -> float:
	# Calculate the productivity based on the infection levels
	return (left_hand.get_productivity() * (left_hand.get_infection()/ left_hand.max_infection)) + (right_hand.get_productivity()- right_hand.get_infection())


func get_stats() -> Dictionary:
	return {
		"infection": left_hand.get_infection(),
		"research_progress": research_progress,
		"net_productivity": get_net_productivity(),
		"evil": evil,
		"fingers": fingers
	}


func brew_potion(potion : Potion) -> void:
	potion_supply.append(potion)
	brewed_potion.emit(potion)

func take_potion(potion : Potion) -> void:
	active_potions.append(potion)
	potion.apply_effect(self)
	consumed_potion.emit(potion)


func _on_left_hand_infection_exceeded() -> void:
	infection_won.emit()
	# Game.on_game_over()

func _on_right_hand_infection_exceeded() -> void:
	infection_won.emit()
	# Game.on_game_over()


func _on_take_potion_pressed() -> void:
	var p = potion_supply.pop_back()
	if p:
		take_potion(p)
		player_turn_over.emit()
	else:
		invalid_action.emit("No potions available!")


func _on_research_btn_pressed() -> void:
	research()

func _on_brew_potion_pressed() -> void:
	brew_potion(Adrenaline.new())
	player_turn_over.emit()


func _on_knife_btn_pressed() -> void:
	knife()


func _on_holy_mantle_btn_pressed() -> void:
	holy_mantle()
