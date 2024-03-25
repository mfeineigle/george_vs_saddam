extends Control

@onready var invincible_check_button: CheckButton = $VBoxContainer/InvincibleHBox/InvincibleCheckButton
@onready var no_story_check_button: CheckButton = $VBoxContainer/NoStoryMode/NoStoryCheckButton
@onready var invincible_h_box: HBoxContainer = %InvincibleHBox
@onready var pause_menu: Control = $"../PauseMenu"
@onready var start_menu: Control = $"../StartMenu"


func _ready() -> void:
	invincible_check_button.button_pressed = Globals.invincible
	no_story_check_button.button_pressed = Globals.no_story_mode
	if not OS.is_debug_build():
		invincible_h_box.hide()


func _on_resume_button_pressed() -> void:
	if not Globals.current_level:
		start_menu.show()
	else:
		$"../PauseMenu".show()
	self.hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_invincible_button_pressed() -> void:
	invincible_check_button.button_pressed = not invincible_check_button.button_pressed
	Globals.invincible = invincible_check_button.button_pressed

func _on_invincible_check_button_pressed() -> void:
	Globals.invincible = invincible_check_button.button_pressed


func _on_no_story_button_pressed() -> void:
	no_story_check_button.button_pressed = not no_story_check_button.button_pressed
	Globals.no_story_mode = no_story_check_button.button_pressed

func _on_no_story_check_button_pressed() -> void:
	Globals.no_story_mode = no_story_check_button.button_pressed
