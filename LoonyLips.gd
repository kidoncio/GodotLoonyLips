extends Control

var player_words: Array = []
var current_story: Dictionary = {
	"prompts": [
		"a name",
		"a noun",
		"adverb",
		"adject"
	],
	"story": "Once upon a time someone called %s ate a %s flavoured sandwich which made him fell all %s inside. It was %s day."
}

onready var PlayerText: LineEdit = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText: Label = $VBoxContainer/DisplayText
onready var PlayerButtonLabel: Label = $VBoxContainer/HBoxContainer/PlayerButtonLabel

func _ready() -> void:
	set_current_story()
	DisplayText.text = "Welcome to Loony Lips! We're going to tell a story and have a wonderful time!\n\n"
	check_player_words_length()
	PlayerText.grab_focus()


func set_current_story() -> void:
	var stories: Array = get_from_json("res://StoryBook.json")
	randomize()
	current_story = stories[randi() % stories.size()]


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
	return player_words.size() == current_story.prompts.size()


func check_player_words_length() -> void:
	if is_story_done():
		end_game()
	else: 
		prompt_player()


func tell_story() -> void:
	DisplayText.text = current_story.story % player_words


func prompt_player() -> void:
	DisplayText.text += "May I have " + current_story.prompts[player_words.size()] + " please?"
	PlayerText.grab_focus()


func get_from_json(filename: String) -> Array:
	var file = File.new()
	file.open(filename, File.READ)
	
	var text: String = file.get_as_text()
	var data: Array = parse_json(text)
	
	file.close()
	
	return data


func end_game() -> void:
	PlayerText.queue_free()
	PlayerButtonLabel.text = "Again!"
	tell_story()