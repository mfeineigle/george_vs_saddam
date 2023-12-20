extends AudioStreamPlayer

@onready var current_scene: Node2D = $"../CurrentScene"

@export var music: Soundtrack
#var music: Dictionary = {
#"LevelSelect": "res://assets/audio/jet_flyover_for_tu-22.mp3",
#"LevelTestA" : "res://assets/audio/distantExplosions.mp3",
#"PageTestA"  : "res://assets/audio/soldiers_leaving_transport.mp3",
#"LevelTestB" : "res://assets/audio/helicopter_flying.mp3",
#}


func _ready() -> void:
	change_music.call_deferred()
	
	
func change_music() -> void:
	var lvl = current_scene.get_child(0).name
	if music.track.has(lvl):
		stream = music.track[lvl]
		play()
	#if music.has(lvl):
		#stream = load(music[lvl])
		#play()


func _on_finished() -> void:
	play() #pseudo-loop
