extends Area2D


var is_found: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_found:
		is_found = true
		print("boom")
		GameEvents.secret_found.emit()
