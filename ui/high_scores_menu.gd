extends Control

@onready var level_option_button: OptionButton = $VBoxContainer/LevelOptionButton

@onready var best_time_label_01: Label = $VBoxContainer/TimeHBox1/BestTimeLabel01
@onready var best_time_label_02: Label = $VBoxContainer/TimeHBox2/BestTimeLabel02
@onready var best_time_label_03: Label = $VBoxContainer/TimeHBox3/BestTimeLabel03
@onready var best_time_label_04: Label = $VBoxContainer/TimeHBox4/BestTimeLabel04
@onready var best_time_label_05: Label = $VBoxContainer/TimeHBox5/BestTimeLabel05


func _ready() -> void:
	level_option_button.add_item("A")
	level_option_button.add_item("B")
	level_option_button.add_item("C")
	var selected_level: String = level_option_button.get_item_text(0)
	var times = Utils.read_best_times(selected_level)
	update_high_scores(times)


func update_high_scores(times) -> void:
	best_time_label_01.text = convert_time_to_displayable(times[0])
	best_time_label_02.text = convert_time_to_displayable(times[1])
	best_time_label_03.text = convert_time_to_displayable(times[2])
	best_time_label_04.text = convert_time_to_displayable(times[3])
	best_time_label_05.text = convert_time_to_displayable(times[4])


func convert_time_to_displayable(time) -> String:
	var mils = int(fmod(time, 1)*1000)
	var secs = int(fmod(time, 60))
	var mins = int(fmod(time, 60*60)/60)
	return str("%02d:%02d.%03d" % [mins, secs, mils])


func _on_level_option_button_item_selected(index: int) -> void:
	var selected_level: String = level_option_button.get_item_text(index).to_lower()
	var times: Array = Utils.read_best_times(selected_level)
	update_high_scores(times)


func _on_reset_button_pressed() -> void:
	var level_idx: int = level_option_button.get_selected_id()
	var level: String = level_option_button.get_item_text(level_idx).to_lower()
	var save_path: String = "res://ui/scores/"+level+"_best_times.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	# 3599 seconds = 59:59.000
	file.store_string(var_to_str([3599, 3599, 3599, 3599, 3599]))


func _on_resume_button_pressed() -> void:
	if not Globals.current_level:
		GameEvents.level_changed.emit("res://ui/start_menu.tscn")
	else:
		$"../PauseMenu".show()
		self.hide()
