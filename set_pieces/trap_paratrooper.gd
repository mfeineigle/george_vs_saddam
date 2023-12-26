extends Area2D

var triggered: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		GameEvents.spawn_an_26.emit()
