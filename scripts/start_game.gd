extends Node
var target_scene : PackedScene = preload("res://scenes/game.tscn")
var red_value = 0.0
var red_increment = 0.05
var max_red = 1.0

func _ready():
	$Background.color = Color(0, 0, 0)
	set_process(true)

func _process(delta):
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_packed(target_scene)
	else:
		red_value = min(red_value + red_increment * delta, max_red)
		if red_value >= max_red:
			get_tree().change_scene_to_packed(target_scene)
		else:
			$Background.color = Color(red_value, 0, 0)
