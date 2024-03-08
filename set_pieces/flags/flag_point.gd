extends Area2D

@onready var flag_pole: Area2D = $FlagPole

var scored: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not scored:
		scored = true
		Globals.flag_captures += 1
		flag_pole.capture_flag()
