extends Area2D

@onready var flag_pole: Area2D = $FlagPole
@onready var collect_sfx: AudioStreamPlayer = $AudioStreamPlayer

var scored: bool = false



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not scored:
		scored = true
		Globals.flag_captures += 1
		collect_sfx.play()
		flag_pole.capture_flag()
