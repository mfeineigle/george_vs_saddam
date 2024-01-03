extends Area2D

@export var key: Keycard
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.texture = key.texture

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.key_picked_up.emit(key)
		queue_free()
