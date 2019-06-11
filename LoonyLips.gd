extends Control

var player_words: Array = []
var prompts: Array = ['a name', 'a noun', 'adverb', 'adject']
var story: String = "Once upon a time someone called %s ate a %s flavoured sandwich which made him fell all %s inside. It was %s day."

onready var PlayerText: LineEdit = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText: Label = $VBoxContainer/DisplayText
onready var PlayerButtonLabel: Label = $VBoxContainer/HBoxContainer/PlayerButtonLabel

func _ready() -> void:
	DisplayText.text = "Welcome to Loony Lips! We're going to tell a story and have a wonderful time!\n\n"
	check_player_words_length()
	PlayerText.grab_focus()


func _on_PlayerText_text_entered(new_text: String) -> void:
	add_to_player_words()


func _on_PlayerButton_pressed() -> void:
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()


func add_to_player_words() -> void:
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()


func is_story_done() -> bool:
	return player_words.size() == prompts.size()


func check_player_words_length() -> void:
	if is_story_done():
		end_game()
	else: 
		prompt_player()


func tell_story() -> void:
	DisplayText.text = story % player_words


func prompt_player() -> void:
	DisplayText.text += "May I have " + prompts[player_words.size()] + " please?"


func end_game() -> void:
	PlayerText.queue_free()
	PlayerButtonLabel.text = "Again!"
	tell_story()