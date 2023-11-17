extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


@export var delay: float = 1.0

func _ready() -> void:
	sprite.hide()
	$Timer.wait_time = delay


func _on_timer_timeout() -> void:
	sprite.show()
	sprite.play("burn")
	particles.emitting = true
	await sprite.animation_finished
	#particles.emitting = false
	sprite.hide()
