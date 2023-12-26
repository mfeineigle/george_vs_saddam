extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func capture_flag() -> void:
	animation_player.play("lower_Iraq_flag")
	await animation_player.animation_finished
	animation_player.play("raise_USA_flag")
	await animation_player.animation_finished
