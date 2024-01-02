extends Area2D

@export var card_color: String


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		KeyManager.add(card_color)
		queue_free()
