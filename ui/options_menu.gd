extends Control

@onready var check_button: CheckButton = $VBoxContainer/InvincibleHBox/CheckButton


func _ready() -> void:
	check_button.button_pressed = Globals.invincible


func _on_resume_button_pressed() -> void:
	if not Globals.current_level:
		GameEvents.level_changed.emit("res://ui/start_menu.tscn")
	else:
		$"../PauseMenu".show()
		self.hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_invincible_button_pressed() -> void:
	check_button.button_pressed = not check_button.button_pressed
	Globals.invincible = check_button.button_pressed
	print(Globals.invincible)
