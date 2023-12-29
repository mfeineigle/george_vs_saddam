extends Control

@onready var time_taken_label: Label = $VBoxContainer/TimeTakenHbox/TimeTakenLabel
@onready var oil_collected_label: Label = $VBoxContainer/OilCollectedHbox/OilCollectedLabel
@onready var soldier_kills_label: Label = $VBoxContainer/SoldiersKillHbox/SoldierKillsLabel
@onready var tank_kills_label: Label = $VBoxContainer/TankKillsHbox/TankKillsLabel
@onready var jeep_kills_label: Label = $VBoxContainer/JeepKillsHbox/JeepKillsLabel
@onready var transport_kills_label: Label = $VBoxContainer/TransportKillsHbox/TransportKillsLabel
@onready var depot_kills_label: Label = $VBoxContainer/DepotKillsHbox/DepotKillsLabel
@onready var radar_tower_kills_label: Label = $VBoxContainer/RadarTowerKillsHbox/RadarTowerKillsLabel
@onready var flags_captured_label: Label = $VBoxContainer/FlagsCapturedHbox/FlagsCapturedLabel
@onready var dmg_taken_label: Label = $VBoxContainer/DamageTakenHbox/DmgTakenLabel
@onready var dmg_done_label: Label = $VBoxContainer/DamageDoneHbox/DmgDoneLabel


var next_level: String = ""

func _ready() -> void:
	GameEvents.level_exited.connect(update_scorecard)


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
	radar_tower_kills_label.text = str(Globals.radar_kills)
	flags_captured_label.text = str(Globals.flag_captures)
	dmg_taken_label.text = str(Globals.total_damage_taken)
	dmg_done_label.text = str(Globals.total_damage_done)
	Globals.reset()
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	visible = false
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
