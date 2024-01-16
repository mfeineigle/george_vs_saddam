extends Area2D

@onready var secret_found: AudioStreamPlayer = $SecretFound

@export_multiline var message: String
@export var id: String

var is_found: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_found:
		is_found = true
		secret_found.play()
		$GPUParticles2D.emitting = false
		GameEvents.secret_found.emit(id, message)
