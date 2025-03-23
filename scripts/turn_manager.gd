extends Node

var player : Player
var current_state: GameState = GameState.START_TURN

signal start_turn_phase
signal player_input_phase
signal end_turn_phase

signal game_over


enum GameState {
	START_TURN,
	PLAYER_INPUT,
	END_TURN
}

func _ready() -> void:
	player = $Player

	# Initialize the game state
	change_state(GameState.START_TURN)


func change_state(new_state: GameState) -> void:
	current_state = new_state
	match current_state:
		GameState.START_TURN:
			start_turn()
		GameState.PLAYER_INPUT:
			player_input()
		GameState.END_TURN:
			end_turn()

func start_turn() -> void:
	print("Starting turn...")
	start_turn_phase.emit()

	change_state(GameState.PLAYER_INPUT)

func player_input() -> void:
	player_input_phase.emit()
	await player.player_turn_over

	change_state(GameState.END_TURN)

func end_turn() -> void:
	end_turn_phase.emit()
	player.end_turn()
	change_state(GameState.START_TURN)

func on_game_over() -> void:
	emit_signal("game_over")


func _on_player_research_complete() -> void:
	pass # Replace with function body.
