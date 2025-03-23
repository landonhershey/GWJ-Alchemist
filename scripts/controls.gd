extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/start_game.tscn")
	if event.is_action_pressed("toggle_shaders"):
		if get_parent().has_node("Overlay"):
			var overlay = get_parent().get_node("Overlay")
			overlay.visible = not overlay.visible
		if get_parent().has_node("Overlay"):
			var overlay: Node = get_parent().get_node("Overlay")
			var v : bool = overlay.visible
			overlay.visible = v
