extends Area2D

@export var next_level: String = "res://"


func _on_exit_level_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.goto_scene(next_level)
