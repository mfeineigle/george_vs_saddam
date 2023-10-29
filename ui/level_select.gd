extends Node2D


var save_path = "res://levels/last_level.save"
var last_level: String


func _ready() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		last_level = file.get_var()
	else:
		last_level = "1"	
	match last_level:
		"1":
			$CanvasGroup/VBoxContainer/Lvl_01_Button.grab_focus()
		"A":
			$CanvasGroup/VBoxContainer/Lvl_A_Button.grab_focus()


func _on_lvl_01_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("1")
	get_tree().change_scene_to_file("res://levels/main.tscn")


func _on_lvl_a_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("A")
	get_tree().change_scene_to_file("res://levels/level_test_a.tscn")





