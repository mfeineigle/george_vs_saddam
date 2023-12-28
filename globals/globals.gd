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

# Score
var soldier_kills: int = 0
var tank_kills: int = 0
var flag_captures: int = 0

# Player
var player_pos: Vector2
var air_drop_timer: int = 100

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
	hp = 55
	oil = 0
	soldier_kills = 0
	tank_kills = 0
	flag_captures = 0
