extends Node
class_name Player

@onready var Game = get_parent()

@export var left_infection : float = 0.0
@export var right_infection : float = 0.0
@export var max_infection : float = 100.0
@export var infection_rate : float = 1.0
@export var infection_rate_multiplier : float = 1.0
@export var infection_color : Color = Color(1, 0, 0)

@export var research_progress : float = 0.0
@export var max_research : float = 100.0
@export var research_rate : float = 1.0
@export var research_rate_multiplier : float = 1.0
@export var research_color : Color = Color(0, 0, 1)

var potion_supply : Array[Potion] = []
var active_potions : Array[Potion] = []

@onready var left_hand : Hand = $LeftHand

@onready var right_hand : Hand = $RightHand


signal player_turn_over


func _ready() -> void:
	# left_hand = Hand.new()
	# right_hand = Hand.new()
	# add_child(left_hand)
	# add_child(right_hand)
	print(get_children())
	print(get_child(0).get_path())
	print(left_hand.get_class())
	left_hand.create(0.0, 0.1, 1.0)
	right_hand.create(0.0, 0.0, 1.0)

	left_hand.connect("infection_complete", Callable(self, "_on_left_hand_infection_exceeded"))
	right_hand.connect("infection_complete", Callable(self, "_on_right_hand_infection_exceeded"))

func player_input() -> void:
	# Handle player input here
	# enable UI elements for player input
	player_turn_over.emit()

	pass




func end_turn() -> void:
	left_hand.end_turn()
	right_hand.end_turn()

	for potion in active_potions:
		potion.end_turn(self)
		if potion.effect_duration <= 0:
			active_potions.erase(potion)

	print(get_stats())

func _on_left_hand_infection_exceeded() -> void:
	print("Left hand infection exceeded!")
	Game.on_game_over()

func _on_right_hand_infection_exceeded() -> void:
	print("Right hand infection exceeded!")
	Game.on_game_over()


func _on_research_btn_pressed() -> void:
	research()

func research():
	if research_progress > max_research:
		print("research complete")
		return

	if research_progress < max_research:
		research_progress += get_net_productivity()* research_rate
		if research_progress > max_research:
			research_progress = max_research

	player_turn_over.emit()
	
	


func get_net_productivity() -> float:
	# Calculate the productivity based on the infection levels
	return left_hand.get_productivity() + right_hand.get_productivity()





func get_stats() -> Dictionary:
	return {
		"left_infection": left_hand.get_infection(),
		"right_infection": right_hand.get_infection(),
		"research_progress": research_progress,
		"net_productivity": get_net_productivity()
	}


func _on_take_potion_pressed() -> void:
	var p = potion_supply.pop_back()
	if p:
		take_potion(p)
	else:
		print("No potions to take")



func brew_potion(potion : Potion) -> void:
	print("Brewing potion")
	potion_supply.append(potion)

func take_potion(potion : Potion) -> void:
	print("Taking potion")
	active_potions.append(potion)
	potion.apply_effect(self)


func _on_brew_potion_pressed() -> void:
	print("Brewing potion")
	brew_potion(Adrenaline.new())
	player_turn_over.emit()
