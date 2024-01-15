extends Area2D

@onready var secret_found: AudioStreamPlayer = $SecretFound


var is_found: bool = false
@export var id: String


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_found:
		is_found = true
		secret_found.play()
		GameEvents.secret_found.emit(id)
