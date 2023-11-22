extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	pass

func fade_to_black() -> void:
	get_tree().paused = true
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	get_tree().paused = false
	

func fade_to_white() -> void:
	get_tree().paused = true
	animation_player.play_backwards("fade_to_black")
	await animation_player.animation_finished
	get_tree().paused = false
