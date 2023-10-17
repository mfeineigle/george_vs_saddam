extends Node2D
class_name DeathComponent

@export var death_animation_player: AnimationPlayer
@export var death_animation: Sprite2D

func _ready():
	death_animation.hide()
	
	
func die() -> void:
	print(get_parent().name, " died.")
	death_animation.show()
	death_animation_player.play("die")
	await death_animation_player.animation_finished
	get_parent().call_deferred("queue_free")
	
