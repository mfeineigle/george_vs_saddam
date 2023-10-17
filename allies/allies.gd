extends Node2D

var blackhawk_scene: PackedScene = preload("res://allies/blackhawk.tscn")

@export var air_drop_delay: int = 1

func _ready() -> void:
	GameEvents.air_drop_called.connect(_on_air_drop_called)


func _on_air_drop_called() -> void:
	if Globals.air_drop_timer >= 100:
		Globals.air_drop_timer -= air_drop_delay
		$AirDropTimer.start()
		var blackhawk = blackhawk_scene.instantiate()
		add_child(blackhawk)
		GameEvents.air_drop_updated.emit()


func _on_air_drop_timer_timeout():
	Globals.air_drop_timer += 1
	GameEvents.air_drop_updated.emit()
	if Globals.air_drop_timer >= 100:
		$AirDropTimer.stop()
