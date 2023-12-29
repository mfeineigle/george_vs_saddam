extends Area2D

@onready var flag_pole: Area2D = $FlagPole

@export var next_level: String = ""


func _on_exit_level_area_body_entered(body: Node2D) -> void:
	await flag_pole.capture_flag()
	if body.is_in_group("player"):
		GameEvents.level_exited.emit(next_level)
