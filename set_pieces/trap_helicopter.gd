extends Area2D

var triggered: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		Globals.trap_triggers += 1
		GameEvents.spawn_mi_24.emit()
