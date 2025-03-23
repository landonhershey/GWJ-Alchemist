extends Control


var infection_ending = preload("res://scenes/endings/infection_ending.tscn")
var evil_ending = preload("res://scenes/endings/evil_ending.tscn")
var research_ending = preload("res://scenes/endings/research_ending.tscn")

@export var default_font : Font

@export var player : Player


@export var message : RichTextLabel

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

func _ready() -> void:
	player.researched.connect(Callable(self,"on_player_researched"))
	player.brewed_potion.connect(Callable(self,"on_player_brewed_potion"))

	research_bar.max_value = player.max_research

	for i in range(1, 11):
		var texture: Texture2D = load("res://sprites/hands/" + "hand_" + str(i) + ".png")
		# hands_sprites.append(texture)
		var image = texture.get_image()
		var half_width = image.get_width() / 2
		var cropped_image = Image.create(half_width, image.get_height(), false, image.get_format())
		cropped_image.blit_rect(image, Rect2(0, 0, half_width, image.get_height()), Vector2(0, 0))
		var cropped_texture = ImageTexture.create_from_image(cropped_image)
		hands_sprites.append(cropped_texture)
	print("Hands sprites loaded: ", hands_sprites)

	for i in range(0, 6):
		var right_hand_texture: Texture2D = load("res://sprites/right_hands/" + "right_hand_" + str(i) + ".png")
		right_hands_sprites.append(right_hand_texture)

	for child in get_children():
		if child is Button:
			child.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

# Action Functions

func display_message(text: String) -> void:
	message.text = text
	# var new_message = RichTextLabel.new()
	# new_message.fit_content = true
	# new_message.text = text
	# messages_container.add_child(new_message)
	# await get_tree().create_timer(4.0).timeout
	# messages_container.remove_child(new_message)
	# new_message.queue_free()



# Signals:

# Game Phase Signals
func _on_turn_manager_start_turn_phase() -> void:
	var infection_progress = player.left_hand.get_infection() / player.left_hand.max_infection
	var infection_number = int(infection_progress * 10)
	print("Infection num: ", infection_number)
	if infection_number > len(hands_sprites) - 1:
		infection_number = len(hands_sprites) - 1
	hand_sprite.texture = hands_sprites[infection_number]
	hand_sprite.modulate = Color(1, 1 - infection_progress, 1 - infection_progress)


	var evil_progress = player.evil / player.evil_max
	evil_bar.value = evil_progress * 100

	var power_progress = player.get_net_productivity() / player.peak_productivity
	power_bar.value = power_progress * 100


func _on_turn_manager_player_input_phase() -> void:
	#for child in messages_container.get_children():
		#messages_container.remove_child(child)
		#child.queue_free()


	pass # Replace with function body.


func _on_turn_manager_end_turn_phase() -> void:
	# Clear messages after a delay
	# await get_tree().create_timer(2.0).timeout
	pass
# Player Action Signals

func on_player_researched(_amount : float) -> void:
	research_bar.value = player.research_progress
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
	display_message(potion.decay_message)


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
