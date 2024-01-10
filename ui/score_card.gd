extends Control

@onready var star_1: TextureRect = $HBoxContainer/star1
@onready var star_2: TextureRect = $HBoxContainer/star2
@onready var star_3: TextureRect = $HBoxContainer/star3
@onready var clang: AudioStreamPlayer = $HBoxContainer/Clang

@onready var time_taken_label: Label = $VBoxContainer/TimeTakenHbox/TimeTakenLabel
@onready var oil_collected_label: Label = $VBoxContainer/OilCollectedHbox/OilCollectedLabel
@onready var soldier_kills_label: Label = $VBoxContainer/SoldiersKillHbox/SoldierKillsLabel
@onready var tank_kills_label: Label = $VBoxContainer/TankKillsHbox/TankKillsLabel
@onready var jeep_kills_label: Label = $VBoxContainer/JeepKillsHbox/JeepKillsLabel
@onready var transport_kills_label: Label = $VBoxContainer/TransportKillsHbox/TransportKillsLabel
@onready var depot_kills_label: Label = $VBoxContainer/DepotKillsHbox/DepotKillsLabel
@onready var scud_launcher_kills_label: Label = $VBoxContainer/ScudLauncherKillsHbox/ScudLauncherKillsLabel
@onready var scud_launcher_triggers_label: Label = $VBoxContainer/ScudLauncherTriggersHbox/ScudLauncherTriggersLabel
@onready var radar_tower_kills_label: Label = $VBoxContainer/RadarTowerKillsHbox/RadarTowerKillsLabel
@onready var radar_tower_triggers_label: Label = $VBoxContainer/RadarTowerTriggersHbox/RadarTowerTriggersLabel
@onready var flags_captured_label: Label = $VBoxContainer/FlagsCapturedHbox/FlagsCapturedLabel
@onready var dmg_taken_label: Label = $VBoxContainer/DamageTakenHbox/DmgTakenLabel
@onready var dmg_healed_label: Label = $VBoxContainer/DamageHealedHbox/DmgHealedLabel
@onready var dmg_done_label: Label = $VBoxContainer/DamageDoneHbox/DmgDoneLabel

var next_level: String = ""


func _ready() -> void:
	GameEvents.level_exited.connect(update_scorecard)
	star_1.hide()
	star_2.hide()
	star_3.hide()


func update_scorecard(_next_level: String = "") -> void:
	next_level = _next_level
	visible = true
	time_taken_label.text = str("%02d:%02d.%03d" % [Globals.mins, Globals.secs, Globals.mils])
	oil_collected_label.text = str(Globals.oil)
	soldier_kills_label.text = str(Globals.soldier_kills)
	tank_kills_label.text = str(Globals.tank_kills)
	jeep_kills_label.text = str(Globals.jeep_kills)
	transport_kills_label.text = str(Globals.transport_kills)
	depot_kills_label.text = str(Globals.depot_kills)
	scud_launcher_kills_label.text = str(Globals.scud_launcher_kills)
	scud_launcher_triggers_label.text = str(Globals.scud_launcher_triggers)
	radar_tower_kills_label.text = str(Globals.radar_kills)
	radar_tower_triggers_label.text = str(Globals.radar_triggers)
	flags_captured_label.text = str(Globals.flag_captures)
	dmg_taken_label.text = str(Globals.total_damage_taken)
	dmg_healed_label.text = str(Globals.total_dollars_collected)
	dmg_done_label.text = str(Globals.total_damage_done)
	update_best_times(Globals.current_level.get_meta("level_number"))
	await display_stars(Globals.current_level.get_meta("TimeGoals"))
	Globals.reset()
	get_tree().paused = true


func update_best_times(level: String) -> void:
	var old_times = Utils.read_best_times(level)
	var new_times = add_new_best_time(old_times, Globals.time)
	save_best_times(level, new_times)

func add_new_best_time(old_times, new_time):
	old_times.append(new_time)
	old_times.sort()
	return old_times.slice(0,5)

func save_best_times(level, times):
	var save_path: String = "res://ui/scores/"+level.to_lower()+"_best_times.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(var_to_str(times))


func display_stars(time_goals: Dictionary) -> void:
	if Globals.secs < time_goals[1]:
		var starTween1 = get_tree().create_tween()
		starTween1.tween_property(star_1, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))
		star_1.show()
		await starTween1.finished
		clang.play()
	if Globals.secs < time_goals[2]:
		var starTween2 = get_tree().create_tween()
		starTween2.tween_property(star_2, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))
		star_2.show()
		await starTween2.finished
		clang.play()
	if Globals.secs < time_goals[3]:
		var starTween3 = get_tree().create_tween()
		starTween3.tween_property(star_3, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))
		star_3.show()
		await starTween3.finished
		clang.play()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	Globals.reset()
	GameEvents.level_changed.emit(Globals.current_level.get_meta("Level"))


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	if next_level:
		GameEvents.level_changed.emit(next_level)
	else:
		_on_restart_button_pressed()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
