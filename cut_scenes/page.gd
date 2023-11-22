extends Control

@export var frames: Array[TextureRect]
@export var next_page: String = "res://"
@export var next_level: String = "res://"


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var progress_bar: ProgressBar = $SkipScene/ProgressBar

var idx: int = 0


func _ready() -> void:
	for frame in $Frames.get_children():
		frame.visible = false
		frame.modulate.a = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if idx < frames.size():
			frames[idx].visible = true
			var frameTween = get_tree().create_tween()
			frameTween.tween_property(frames[idx], "modulate:a", 1, 1)
			idx += 1
		elif next_page:
			audio_stream_player_2d.play()
			await audio_stream_player_2d.finished
			SceneManager.goto_scene(next_page)
		else:
			SceneManager.goto_scene(next_level)


func _on_skip_timer_timeout() -> void:
	if Input.is_action_pressed("shoot"):  
		progress_bar.value += 5  #Button is pressed, increase the progress
		if progress_bar.value >= 10:
			$SkipScene.visible = true
	else:  
		progress_bar.value = 0  #The button wasn't down during this tick, reset progress
	if progress_bar.value >= 100:
		SceneManager.goto_scene(next_level)
