extends Area2D

@onready var roof_animation: AnimationPlayer = $RoofAnimation


func _on_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		roof_animation.play("fade_out")


func _on_door_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		roof_animation.play_backwards("fade_out")
