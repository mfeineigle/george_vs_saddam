extends Control

@export var frames: Array[TextureRect]
@export var next_page: PackedScene
@export var next_level: PackedScene


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var progress_bar: ProgressBar = $SkipScene/ProgressBar

var idx: int = 0


func _ready() -> void:
	for frame in $Frames.get_children():
		frame.visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if idx < frames.size():
			frames[idx].visible = true
			idx += 1
		elif next_page:
			audio_stream_player_2d.play()
			await audio_stream_player_2d.finished
			get_tree().change_scene_to_packed(next_page)
		else:
			get_tree().change_scene_to_packed(next_level)


func _on_skip_timer_timeout() -> void:
	if Input.is_action_pressed("shoot"):  
		progress_bar.value += 5  #Button is pressed, increase the progress
		if progress_bar.value >= 10:
			$SkipScene.visible = true
	else:  
		progress_bar.value = 0  #The button wasn't down during this tick, reset progress
	if progress_bar.value >= 100:
		get_tree().change_scene_to_packed(next_level)
