extends Area2D

@onready var flag_usa: Polygon2D = $flag_USA
@onready var flag_iraq: Polygon2D = $flag_Iraq
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# add some variance to the shader animation
	var speed_offset: float = randf_range(-0.05, 0.05)
	flag_usa.material.set_shader_parameter("speed", 2 + speed_offset)
	flag_iraq.material.set_shader_parameter("speed", 2 + speed_offset)
	var freq_y_offset: float = randf_range(-0.05, 0.05)
	flag_usa.material.set_shader_parameter("frequency_y", 2 + freq_y_offset)
	flag_iraq.material.set_shader_parameter("frequency_y", 2 + freq_y_offset)


func capture_flag() -> void:
	animation_player.play("lower_Iraq_flag")
	await animation_player.animation_finished
	animation_player.play("raise_USA_flag")
	await animation_player.animation_finished
