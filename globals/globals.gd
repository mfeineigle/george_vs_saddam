extends Node

var invincible: bool = false

var air_drop_timer: int = 100
var player_pos: Vector2
var current_level: Node2D


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
