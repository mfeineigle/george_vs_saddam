extends Control

@onready var quit_button: Button = $Buttons/VBoxContainer/QuitButton

var paused: bool = false
var save_path = "res://levels/last_level.save"


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		_on_paused()


func _on_paused() -> void:
	if not paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		get_tree().paused = true
		quit_button.grab_focus()
	else:
		self.hide()
		get_tree().paused = false
	paused = not paused


func _on_restart_level_pressed() -> void:
	get_tree().paused = false
	Globals.reset()
	GameEvents.level_changed.emit(Globals.current_level.get_meta("Level"))


func _on_level_select_pressed() -> void:
	get_tree().paused = false
	GameEvents.level_changed.emit("res://ui/level_select.tscn")


func _on_level_save_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Globals.current_level.get_meta("Level"))


func _on_quit_button_pressed():
	get_tree().quit()
