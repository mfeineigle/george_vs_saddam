extends Sprite2D

@export var radar_wave_speed: float = 0.01
var shader_value: float = 1.1 

func _process(_delta: float) -> void:
	shader_value -= radar_wave_speed
	material.set_shader_parameter("DisappearHeight", shader_value)
	if shader_value <= -1.1:
		shader_value = 1.1
