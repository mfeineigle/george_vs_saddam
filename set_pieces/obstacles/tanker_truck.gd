extends StaticBody2D

@export var hit_sounds: Array[AudioStreamMP3]


func hit(_damage) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
