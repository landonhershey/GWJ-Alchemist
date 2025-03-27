extends Node
# @export var target_scene : PackedScene = preload("res://scenes/game.tscn")


func _ready() -> void:
	set_process(true)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://scenes/start_game.tscn")
