extends Control


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
