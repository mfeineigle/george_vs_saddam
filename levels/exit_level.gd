extends Area2D

@onready var flag_pole: Area2D = $FlagPole

@export var next_level: String = ""


func _on_exit_level_area_body_entered(body: Node2D) -> void:
	flag_pole.animation_player.play("lower_Iraq_flag")
	await flag_pole.animation_player.animation_finished
	flag_pole.animation_player.play("raise_USA_flag")
	await flag_pole.animation_player.animation_finished
	if body.is_in_group("player"):
		GameEvents.level_changed.emit(next_level)
