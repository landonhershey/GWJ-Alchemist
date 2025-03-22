extends Control

@export var player : Player

@onready var research_bar = $ResearchBar
@onready var evil_bar = $EvilBar
@onready var hand_sprite = $Hands

@onready var hands_folder =  "res://sprites/hands/"
@export var hands_sprites : Array[Texture2D] = []

@onready var potion_container = $PotionContainer

func _ready() -> void:
	print("UIManager ready")
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

func on_player_researched(amount : float) -> void:
	research_bar.value += amount
	# print("Research progress updated: ", research_bar.value)





func _on_game_over() -> void:
	pass # Replace with function body.


func _on_player_infection_won() -> void:
	pass # Replace with function body.


func _on_player_research_complete() -> void:
	pass # Replace with function body.


func _on_turn_manager_start_turn_phase() -> void:
	var infection_progress = player.left_hand.get_infection() / player.left_hand.max_infection
	var infection_number = int(infection_progress * 10)
	print("Infection num: ", infection_number)
	if infection_number > len(hands_sprites) - 1:
		infection_number = len(hands_sprites) - 1
	hand_sprite.texture = hands_sprites[infection_number]

	var evil_progress = player.evil / player.evil_max
	evil_bar.value = evil_progress * 100
	


func _on_player_brewed_potion(_potion: Potion) -> void:
	var container = $PotionContainer
	var tex_rect = TextureRect.new()
	tex_rect.texture = load("res://sprites/brewing_potion.png")
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Keep sprite aspect ratio
	container.add_child(tex_rect)


func _on_player_consumed_potion(_potion: Potion) -> void:
	if potion_container.get_child_count() > 0:
		potion_container.remove_child(potion_container.get_child(0))
