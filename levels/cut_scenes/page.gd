extends Control

@export var frames: Array[TextureRect]
@export var next_page: String = ""
@export var next_level: String = ""
@export var next_cutscene: String = ""


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var skip_frame: TextureRect = $Background/SkipFrame
@onready var progress_bar: ProgressBar = $Background/SkipFrame/ProgressBar

var idx: int = 0


func _ready() -> void:
	for frame in $Frames.get_children():
		frame.visible = false
		frame.modulate.a = 0
	if idx < frames.size():
		goto_next_frame() # auto show the first frame


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		if idx < frames.size():
			goto_next_frame()
		elif next_page:
			goto_next_page()
		elif Globals.story_mode and next_cutscene:
			GameEvents.level_changed.emit(next_cutscene)
		else:
			GameEvents.level_changed.emit(next_level)


func goto_next_frame() -> void:
	frames[idx].visible = true
	var frameTween = get_tree().create_tween()
	frameTween.tween_property(frames[idx], "modulate:a", 1, 1)
	idx += 1


func goto_next_page() -> void:
	set_process_input(false) # don't allow input on page turn
	audio_stream_player_2d.play()
	# TODO page turn animation
	await audio_stream_player_2d.finished
	GameEvents.level_changed.emit(next_page)
	set_process_input(true)


func _on_skip_timer_timeout() -> void:
	if Input.is_action_pressed("shoot"):  
		progress_bar.value += 5  #Button is pressed, increase the progress
		if progress_bar.value >= 20:
			skip_frame.visible = true
	else:  
		progress_bar.value = 0  #The button wasn't down during this tick, reset progress
	if progress_bar.value >= 100:
		if Globals.story_mode and next_cutscene:
			GameEvents.level_changed.emit(next_cutscene)
		else:
			GameEvents.level_changed.emit(next_level)
