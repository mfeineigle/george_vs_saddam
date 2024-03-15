extends Area2D

@export var children: Node2D

@onready var screaming_children: AudioStreamPlayer = $AudioStreamPlayer

var triggered: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		screaming_children.play()


func _on_dead_children_check_timer_timeout() -> void:
	if children.get_child_count() <= 0:
		queue_free()
