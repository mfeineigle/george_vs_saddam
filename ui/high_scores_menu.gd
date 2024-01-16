extends Control

@onready var level_option_button: OptionButton = $VBoxContainer/LevelOptionButton

@onready var best_time_label_01: Label = $VBoxContainer/FirstHBox/BestTimeLabel01
@onready var best_time_label_02: Label = $VBoxContainer/SecondHBox/BestTimeLabel02
@onready var best_time_label_03: Label = $VBoxContainer/ThirdHbox/BestTimeLabel03
@onready var best_time_label_04: Label = $VBoxContainer/FourthHbox/BestTimeLabel04
@onready var best_time_label_05: Label = $VBoxContainer/FifthHbox/BestTimeLabel05

@onready var stars_1: HBoxContainer = $VBoxContainer/FirstHBox/Stars1
@onready var stars_2: HBoxContainer = $VBoxContainer/SecondHBox/Stars2
@onready var stars_3: HBoxContainer = $VBoxContainer/ThirdHbox/Stars3
@onready var stars_4: HBoxContainer = $VBoxContainer/FourthHbox/Stars4
@onready var stars_5: HBoxContainer = $VBoxContainer/FifthHbox/Stars5
@onready var all_stars: Array = [stars_1, stars_2, stars_3, stars_4, stars_5]

@onready var secrets_1: HBoxContainer = $VBoxContainer/FirstHBox/Secrets1
@onready var secrets_2: HBoxContainer = $VBoxContainer/SecondHBox/Secrets2
@onready var secrets_3: HBoxContainer = $VBoxContainer/ThirdHbox/Secrets3
@onready var secrets_4: HBoxContainer = $VBoxContainer/FourthHbox/Secrets4
@onready var secrets_5: HBoxContainer = $VBoxContainer/FifthHbox/Secrets5
@onready var all_secrets: Array = [secrets_1, secrets_2, secrets_3, secrets_4, secrets_5]

@onready var secret_label: Label = $VBoxContainer/SecretMessages/SecretLabel
@onready var secret_label_2: Label = $VBoxContainer/SecretMessages/SecretLabel2
@onready var secret_label_3: Label = $VBoxContainer/SecretMessages/SecretLabel3
@onready var all_secret_labels: Array = [secret_label, secret_label_2, secret_label_3]

@onready var redacted_texture_rect: TextureRect = $VBoxContainer/SecretMessages/RedactedTextureRect
@onready var redacted_texture_rect_2: TextureRect = $VBoxContainer/SecretMessages/RedactedTextureRect2
@onready var redacted_texture_rect_3: TextureRect = $VBoxContainer/SecretMessages/RedactedTextureRect3
@onready var all_redacted_textures: Array = [redacted_texture_rect, redacted_texture_rect_2, redacted_texture_rect_3]


func _ready() -> void:
	level_option_button.add_item("A")
	level_option_button.add_item("B")
	level_option_button.add_item("C")
	_on_level_option_button_item_selected(0)


func _on_level_option_button_item_selected(index: int) -> void:
	var selected_level: String = level_option_button.get_item_text(index).to_lower()
	var times: Array = Utils.read_best_times(selected_level)
	var secrets: Dictionary = Utils.read_secrets(selected_level)
	var level = load("res://levels/"+"level_test_"+selected_level+".tscn").instantiate()
	var time_goals: Dictionary = level.get_meta("TimeGoals")
	var total_secrets: int = level.get_meta("TotalSecrets")
	update_stars(times, time_goals)
	update_high_scores(times)
	update_secrets(secrets)
	update_redacted(secrets, total_secrets)


func update_stars(times: Array, time_goals: Dictionary) -> void:
	for i in range(times.size()):
		for star in all_stars[i].get_children():
			star.hide()
		if times[i] < time_goals[1]:
			all_stars[i].get_child(0).show()
		if times[i] < time_goals[2]:
			all_stars[i].get_child(1).show()
		if times[i] < time_goals[3]:
			all_stars[i].get_child(2).show()


func update_secrets(secrets: Dictionary) -> void:
	for i in range(5):
		for secret in all_secrets[i].get_children():
			secret.hide()
		if secrets.size() > 0:
			all_secrets[i].get_child(0).show()
		if secrets.size() > 1:
			all_secrets[i].get_child(1).show()
		if secrets.size() > 2:
			all_secrets[i].get_child(2).show()


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


func update_redacted(secrets: Dictionary, total_secrets: int) -> void:
	for i in all_redacted_textures:
		i.hide()
	for i in all_secret_labels:
		i.hide()
	for i in range(total_secrets):
		if i < secrets.size():
			if secrets.keys()[i]:
				all_secret_labels[i].show()
				all_secret_labels[i].text = secrets.values()[i]["msg"]
		else:
			all_redacted_textures[i].show()


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
