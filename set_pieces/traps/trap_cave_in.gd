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
## Nav region to block/allow after the trap triggers
@export var nav_region_starting_rocks: NavigationRegion2D
@export var nav_region_finished_rocks: NavigationRegion2D

var triggered: bool = false


func _ready() -> void:
	audio_stream_player.stream = cave_in_sound_effect
	for boulder in boulders.get_children():
		if invisible_boulders:
			boulder.visible = false
		boulder.process_mode = Node.PROCESS_MODE_DISABLED
	if nav_region_starting_rocks:
		nav_region_starting_rocks.enabled = false
		nav_region_starting_rocks.use_edge_connections = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		_update_nav_regions()
		Globals.trap_triggers += 1
		animation_player.play("cave_in")
		audio_stream_player.play()
		for boulder in boulders.get_children():
			boulder.process_mode = Node.PROCESS_MODE_INHERIT

func _update_nav_regions() -> void:
	if nav_region_starting_rocks:
		nav_region_starting_rocks.enabled = true
		nav_region_starting_rocks.use_edge_connections = true
	if nav_region_finished_rocks:
		nav_region_finished_rocks.enabled = false
		nav_region_finished_rocks.use_edge_connections = false
