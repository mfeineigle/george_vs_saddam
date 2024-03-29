extends Node

var current_level: Node2D

# Timer
var time: float
var mils: int
var secs: int
var mins: int

# Modes
var invincible: bool = false
var story_mode: bool = false
var no_story_mode: bool = false

# Score
var soldier_kills: int = 0
var tank_kills: int = 0
var jeep_kills: int = 0
var transport_kills: int = 0
var depot_kills: int = 0
var radar_kills: int = 0
var radar_triggers: int = 0
var scud_launcher_kills: int = 0
var scud_launcher_triggers: int = 0
var civilian_kills: int = 0
var flag_captures: int = 0
var secrets_found_this_run: int = 0
var trap_triggers: int = 0

# Player
var player_pos: Vector2
var air_drop_timer: int = 100
var total_damage_taken: int = 0
var total_damage_done: int = 0
var total_dollars_collected: int = 0

var hp: int = 55:
	get:
		return hp
	set(value):
		hp = value
		GameEvents.stats_changed.emit()


var oil: int = 0:
	get:
		return oil
	set(value):
		oil = value
		GameEvents.stats_changed.emit()


func reset() -> void:
	time = 0
	hp = 55
	oil = 0
	WeaponsManager.weapons = []
	KeyManager.keys = []
	soldier_kills = 0
	tank_kills = 0
	flag_captures = 0
	secrets_found_this_run = 0
	total_damage_done = 0
	total_damage_taken = 0
