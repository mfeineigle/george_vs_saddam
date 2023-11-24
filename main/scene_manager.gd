extends Node2D

@onready var current_scene: Node2D = $CurrentScene
@onready var fade_scene: CanvasLayer = $FadeScene
@onready var music_manager: AudioStreamPlayer = $MusicManager


func _ready() -> void:
	GameEvents.level_changed.connect(goto_scene)
	var init_scene= ResourceLoader.load("res://ui/level_select.tscn")
	current_scene.add_child(init_scene.instantiate())


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	await fade_scene.fade_to_black()
	current_scene.get_child(0).free()
	var new_scene = ResourceLoader.load(path).instantiate()
	current_scene.add_child(new_scene)
	await fade_scene.fade_to_white()
	music_manager.change_music()
	#get_tree().current_scene = current_scene.get_child(0)
