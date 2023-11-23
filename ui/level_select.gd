extends Node2D


var save_path = "res://levels/last_level.save"
var last_level: String


func _ready() -> void:
	last_level = "1"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file.get_length() > 0:
			last_level = file.get_var()
	match last_level:
		"1":
			$CanvasGroup/VBoxContainer/Lvl_01_Button.grab_focus()
		"A":
			$CanvasGroup/VBoxContainer/Lvl_A_Button.grab_focus()
		"B":
			$CanvasGroup/VBoxContainer/Lvl_B_Button.grab_focus()
		"C":
			$CanvasGroup/VBoxContainer/Lvl_C_Button.grab_focus()


func _on_lvl_01_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("1")
	GameEvents.level_changed.emit("res://levels/level_01.tscn")


func _on_lvl_a_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("A")
	GameEvents.level_changed.emit("res://levels/level_test_a.tscn")


func _on_lvl_b_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("B")
	GameEvents.level_changed.emit("res://levels/level_test_b.tscn")


func _on_lvl_c_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("C")
	GameEvents.level_changed.emit("res://levels/level_test_c.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


