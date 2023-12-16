extends Control




func _on_start_button_pressed() -> void:
	GameEvents.level_changed.emit("res://levels/level_test_a.tscn")





func _on_continue_button_pressed() -> void:
	var save_path = "res://levels/last_level.save"
	var last_level = "1"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file.get_length() > 0:
			last_level = file.get_var()
	if last_level in ["A", "B", "C"]:
		GameEvents.level_changed.emit("res://levels/level_test_"+last_level.to_lower()+".tscn")
	else:
		GameEvents.level_changed.emit("res://levels/level_01.tscn")
