extends Node2D


var save_path = "user://data/levels/last_level.save"
var last_level: String

@onready var lvl_01_button: Button = %Lvl_01_Button
@onready var lvl_a_button: Button = %Lvl_A_Button
@onready var lvl_b_button: Button = %Lvl_B_Button
@onready var lvl_c_button: Button = %Lvl_C_Button
@onready var lvl_d_button: Button = %Lvl_D_Button
@onready var lvl_z_button: Button = %Lvl_Z_Button
@onready var start_menu_button: Button = %StartMenu_Button
@onready var quit_button: Button = %Quit_Button


func _ready() -> void:
	last_level = "1"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file.get_length() > 0:
			last_level = file.get_var()
			print(last_level)
	match last_level:
		"res://levels/level_01.tscn":
			lvl_01_button.grab_focus()
		"res://levels/level_test_a.tscn":
			lvl_a_button.grab_focus()
		"res://levels/level_test_b.tscn":
			lvl_b_button.grab_focus()
		"res://levels/level_test_c.tscn":
			lvl_c_button.grab_focus()
		"res://levels/level_test_d.tscn":
			lvl_d_button.grab_focus()
		"res://levels/level_test_z.tscn":
			lvl_z_button.grab_focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_start_menu_button_pressed()


func _on_lvl_01_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("res://levels/level_01.tscn")
	GameEvents.level_changed.emit("res://levels/level_01.tscn")


func _on_lvl_a_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("res://levels/level_test_a.tscn")
	GameEvents.level_changed.emit("res://levels/level_test_a.tscn")


func _on_lvl_b_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("res://levels/level_test_b.tscn")
	GameEvents.level_changed.emit("res://levels/level_test_b.tscn")


func _on_lvl_c_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("res://levels/level_test_c.tscn")
	GameEvents.level_changed.emit("res://levels/level_test_c.tscn")


func _on_lvl_d_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("res://levels/level_test_d.tscn")
	GameEvents.level_changed.emit("res://levels/level_test_d.tscn")


func _on_lvl_z_button_pressed() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var("user://levels/level_test_z.tscn")
	GameEvents.level_changed.emit("res://levels/level_test_z.tscn")


func _on_start_menu_button_pressed() -> void:
	GameEvents.level_changed.emit("res://ui/start_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
