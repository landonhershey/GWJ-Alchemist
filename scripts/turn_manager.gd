extends Node

# var player = preload("res://scripts/player.gd")

var player : Player
var current_state: GameState = GameState.START_TURN

signal start_turn_phase
signal player_input_phase
signal end_turn_phase

signal game_over

enum Ending {
	INFECTION,
	RESEARCH
}


# Enum for the different states
enum GameState {
	START_TURN,
	PLAYER_INPUT,
	END_TURN
}

func _ready() -> void:
	# player = Player.new()
	# add_child(player)
	player = $Player

	# Initialize the game state
	change_state(GameState.START_TURN)


# Function to change the state
func change_state(new_state: GameState) -> void:
	current_state = new_state
	match current_state:
		GameState.START_TURN:
			start_turn()
		GameState.PLAYER_INPUT:
			player_input()
		GameState.END_TURN:
			end_turn()

# Logic for the START_TURN state
func start_turn() -> void:
	print("Starting turn...")
	start_turn_phase.emit()
	# Add your start turn logic here

	# UI changes, possibly dialogue boxes, etc.
	change_state(GameState.PLAYER_INPUT)

# Logic for the PLAYER_INPUT state
func player_input() -> void:
	print("Waiting for player input...")
	# wait for player input (this is just a placeholder)
	player_input_phase.emit()
	await player.player_turn_over

	change_state(GameState.END_TURN)

# Logic for the END_TURN state
func end_turn() -> void:
	end_turn_phase.emit()
	player.end_turn()
	print("Ending turn...")
	
	# Add your end turn logic here
	# Transition back to START_TURN for the next turn
	change_state(GameState.START_TURN)

func on_game_over() -> void:
	print("Game Over!")
	emit_signal("game_over")


func _on_player_research_complete() -> void:
	pass # Replace with function body.
