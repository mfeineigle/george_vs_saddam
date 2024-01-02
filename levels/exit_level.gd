extends Area2D

@export var flag_pole: Area2D
@export var next_level: String = ""


func _on_exit_level_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await flag_pole.capture_flag()
		GameEvents.level_exited.emit(next_level)
