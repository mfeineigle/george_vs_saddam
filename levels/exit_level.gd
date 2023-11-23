extends Area2D

@export var next_level: String = ""


func _on_exit_level_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.level_changed.emit(next_level)
