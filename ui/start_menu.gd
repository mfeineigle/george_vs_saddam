extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title: TextureRect = $Background/VBoxContainer/TitleHBox/TitleTextureRect
@onready var start_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/StartButton
@onready var continue_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/ContinueButton
@onready var options_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/OptionsButton
@onready var story_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/StoryButton
@onready var level_select_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/LevelSelectButton
@onready var quit_button: Button = $Background/VBoxContainer/MarginContainer/ButtonsVBox/QuitButton


func _ready() -> void:
	animation_player.play("fade_title")
	var title_tween = get_tree().create_tween().set_parallel()
	title_tween.tween_property(title, "position:y", 0, 1.0).from(-500)
	#title_tween.tween_property(title, "self_modulate:a", 1.0, 1.5).from(0.0)
	title_tween.tween_property(start_button, "position:x", 0, 1.0).from(-1000)
	title_tween.tween_property(continue_button, "position:x", 0, 1.0).from(1000)
	title_tween.tween_property(options_button, "position:x", 0, 1.0).from(-2000)
	title_tween.tween_property(story_button, "position:x", 0, 1.0).from(2000)
	title_tween.tween_property(level_select_button, "position:x", 0, 1.0).from(-3000)
	title_tween.tween_property(quit_button, "position:x", 0, 1.0).from(3000)


func _on_start_button_pressed() -> void:
	GameEvents.level_changed.emit("res://levels/level_test_a.tscn")


func _on_continue_button_pressed() -> void:
	var save_path = "res://levels/last_level.save"
	var last_level = "res://levels/level_test_a.tscn"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file.get_length() > 0:
			last_level = file.get_var()
	GameEvents.level_changed.emit(last_level)


func _on_level_select_button_pressed() -> void:
	GameEvents.level_changed.emit("res://ui/level_select.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
