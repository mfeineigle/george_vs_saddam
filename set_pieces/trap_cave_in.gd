extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## Holds the boulders to cave in
@export var boulders: Node2D
## Do the boulders start invisible?
@export var invisible_boulders: bool = false
## Sound to play when trap triggers
@export var cave_in_sound_effect: AudioStream
## Unique animation per trap, add per instance
@export var animation_player: AnimationPlayer
var triggered: bool = false


func _ready() -> void:
	audio_stream_player.stream = cave_in_sound_effect
	for boulder in boulders.get_children():
		if invisible_boulders:
			boulder.visible = false
		boulder.process_mode = Node.PROCESS_MODE_DISABLED


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		animation_player.play("cave_in")
		audio_stream_player.play()
