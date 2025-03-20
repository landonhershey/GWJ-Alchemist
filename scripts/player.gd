extends Node


class_name Player

const Game = preload("res://scripts/game.gd")

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

var active_potions : Array[Potion] = []

var left_hand : Hand
var right_hand : Hand   


signal player_decision_made


func _ready() -> void:
    left_hand = Hand.new(0.0, 0.1, 1.0)
    right_hand = Hand.new(0.0, 0.0, 1.0)

    left_hand.connect("infection_complete", Callable(self, "_on_left_hand_infection_exceeded"))
    right_hand.connect("infection_complete", Callable(self, "_on_right_hand_infection_exceeded"))

func player_input() -> void:
    # Handle player input here
    # enable UI elements for player input
    player_decision_made.emit()

    pass


func take_potion(potion : Potion) -> void:
    potion.apply_effect()
    # left_hand.reduce_infection(potion.infection_reduction)
    # right_hand.reduce_infection(potion.infection_reduction)

    

func end_turn() -> void:
    left_hand.end_turn()
    right_hand.end_turn()

func _on_left_hand_infection_exceeded() -> void:
    print("Left hand infection exceeded!")

func _on_right_hand_infection_exceeded() -> void:
    print("Right hand infection exceeded!")
    Game.game_over()


func research():
    if research_progress > max_research:
        print("research complete")
        return


    if research_progress < max_research:
        research_progress += research_rate * research_rate_multiplier
        if research_progress > max_research:
            research_progress = max_research

func get_net_productivity() -> float:
    # Calculate the productivity based on the infection levels
    return (1.0 - (left_hand.get_infection())) + (1.0 - (right_hand.get_infection()))