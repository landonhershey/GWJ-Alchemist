extends Control


var infection_ending = preload("res://scenes/endings/infection_ending.tscn")
var evil_ending = preload("res://scenes/endings/evil_ending.tscn")
var research_ending = preload("res://scenes/endings/research_ending.tscn")

@export var default_font : Font

@export var player : Player


@export var message : RichTextLabel
@export var message_temp: RichTextLabel

@export var power_bar : ProgressBar
@export var research_bar : ProgressBar
@export var evil_bar : ProgressBar
@export var hand_sprite : Sprite2D
@onready var right_hand_sprite = $RightHand
@onready var hands_folder =  "res://sprites/hands/"
@export var hands_sprites : Array[Texture2D] = []

@onready var right_hands_folder =  "res://sprites/right_hands/"
var right_hands_sprites : Array[Texture2D] = []

@export var messages_container : VBoxContainer
@export var potion_container : HBoxContainer

@export var overlay : ColorRect
var evil_last_turn : float = 0.0 # track value of player evil last turn (bad practice I know)

func _ready() -> void:
	player.researched.connect(Callable(self,"on_player_researched"))
	player.brewed_potion.connect(Callable(self,"on_player_brewed_potion"))

	research_bar.max_value = player.max_research

	for i in range(1, 11):
		var texture: Texture2D = load("res://sprites/hands/" + "hand_" + str(i) + ".png")
		var image = texture.get_image()
		var half_width = image.get_width() / 2
		var cropped_image = Image.create(half_width, image.get_height(), false, image.get_format())
		cropped_image.blit_rect(image, Rect2(0, 0, half_width, image.get_height()), Vector2(0, 0))
		var cropped_texture = ImageTexture.create_from_image(cropped_image)
		hands_sprites.append(cropped_texture)
	for i in range(0, 6):
		var right_hand_texture: Texture2D = load("res://sprites/right_hands/" + "right_hand_" + str(i) + ".png")
		right_hands_sprites.append(right_hand_texture)

	for child in get_children():
		if child is Button:
			child.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
	#initialize shader parameters
	overlay.set_shader()


# Action Functions






func display_message(text: String) -> void:
	message.text = text

func display_temp_message(text: String) -> void:
	message_temp.text = text



# Signals:

# Game Phase Signals
func _on_turn_manager_start_turn_phase() -> void:
	var infection_progress = player.left_hand.get_infection() / player.left_hand.max_infection
	var infection_number = int(infection_progress * 10)
	if infection_number > len(hands_sprites) - 1:
		infection_number = len(hands_sprites) - 1
	hand_sprite.texture = hands_sprites[infection_number]
	hand_sprite.modulate = Color(1, 1 - infection_progress, 1 - infection_progress)


	var evil_progress = player.evil / player.evil_max
	evil_bar.value = evil_progress * 100

	if evil_progress > 0.9 and evil_last_turn <= 0.9:
		display_temp_message("You are losing yourself to the darkness...")
	elif evil_progress > 0.6 and evil_last_turn <= 0.6:
		display_temp_message("You feel the darkness consuming you...")
	elif evil_progress > 0.3 and evil_last_turn <= 0.3:
		display_temp_message("You feel a dark presence growing...")

	evil_last_turn = evil_progress

	print("Player left hand infection: ", player.left_hand.get_infection())
	if player.left_hand.infection == 0.9:
		display_temp_message("Your hand is almost gone...")
	elif player.left_hand.infection == 0.6:
		display_temp_message("Your hand is starting to feel numb...")
	# elif player.left_hand.infection == 0.2:
	# 	if overlay.visible == false:
	# 		overlay.visible = true
	# 	display_temp_message("I feel strange...")
	elif player.left_hand.infection == 0.1:
		display_temp_message("You feel a slight itch in your hand...")
		
	if research_bar.value > 400:
		display_temp_message("Knowledge is within your grasp")
	if research_bar.value == 500:
		message.text = ""
		display_temp_message("You wake up")



	var power_progress = player.get_net_productivity() / player.peak_productivity
	power_bar.value = power_progress * 100
	modify_overlay(0, true)


func modify_overlay(research_amount : float, evil : bool) -> void:
	var shader_material: ShaderMaterial = overlay.material
	

	if research_amount > 0:
		var current_effect = shader_material.get_shader_parameter("effect_strength")
		print("SHADER EFFECT", current_effect)
		shader_material.set_shader_parameter("effect_strength", max(current_effect-(research_amount), 0))
#	
	if evil:

		var current_color = shader_material.get_shader_parameter("mix_color")
		print("CURRENT COLOR SHADER: ", current_color)
		shader_material.set_shader_parameter("mix_color", Color(0.01*max(1.0, (evil_bar.value/2.5)), 0.01, 0.01, 1))





func _on_turn_manager_player_input_phase() -> void:
	#for child in messages_container.get_children():
		#messages_container.remove_child(child)
		#child.queue_free()

	pass # Replace with function body.


func _on_turn_manager_end_turn_phase() -> void:
	message_temp.text = ""
	# Clear messages after a delay
	# await get_tree().create_timer(2.0).timeout
	pass
# Player Action Signals

func on_player_researched(amount : float) -> void:
	research_bar.value = player.research_progress
	modify_overlay(amount, true)
	# print("Research progress updated: ", research_bar.value)

func _on_player_brewed_potion(_potion: Potion) -> void:
	var tex_rect = TextureRect.new()
	tex_rect.texture = load("res://sprites/potions/pink_potion.png")
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Keep sprite aspect ratio
	potion_container.add_child(tex_rect)
	display_message("You brewed adrenaline!")


func _on_player_consumed_potion(potion: Potion) -> void:
	if potion_container.get_child_count() > 0:
		potion_container.remove_child(potion_container.get_child(0))
	display_message(potion.message)


func _on_player_cut_off_finger(fingers: int) -> void:
	var pic_index = 5 - fingers
	right_hand_sprite.texture = right_hands_sprites[pic_index]
	display_message("Your powers have doubled, at a cost...")





func _on_player_invalid_action(user_message : String = "You can't do that right now...") -> void:
	message.text = user_message


func _on_player_potion_effect_ended(potion:Potion) -> void:
	display_temp_message(potion.decay_message)


# Ending Signals

func _on_game_over() -> void:
	pass # Replace with function body.


func _on_player_infection_won() -> void:
	get_tree().change_scene_to_packed(infection_ending)


func _on_player_research_complete() -> void:
	print("Research complete!")
	get_tree().change_scene_to_packed(research_ending)

func _on_player_evil_won() -> void:
	get_tree().change_scene_to_packed(evil_ending)

func _on_player_pray() -> void:
	display_message("You feel purified")
