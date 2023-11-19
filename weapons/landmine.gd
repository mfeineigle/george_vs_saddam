extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


@export var damage: int = 5
@export var knockback_strength: int = 3000


func _on_body_entered(body: Node2D) -> void:
	var dir = global_position.direction_to(body.global_position)
	if body.has_method("hit"):
		body.hit(damage)
	if body.has_method("knockback"):
		body.knockback(dir, knockback_strength)
	animation_player.play("explode")
	audio_stream_player_2d.play()
	set_deferred("monitoring", false)
	await audio_stream_player_2d.finished
	queue_free()
