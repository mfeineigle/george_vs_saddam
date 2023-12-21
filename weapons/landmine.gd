extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shockwave_rect: ColorRect = $ShockwaveCanvas/ShockwaveRect


@export var damage: int = 5
@export var knockback_strength: int = 3000


func _ready() -> void:
	shockwave_rect.visible = false


func shockwave() -> void:
	# get the position relative to the viewport
	var pos = get_canvas_transform().origin + global_position
	# normalize the pos in UV coordinates for the shader
	var center = pos / (get_window().size as Vector2)
	shockwave_rect.material.set_shader_parameter("center", center)
	shockwave_rect.visible = true
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(shockwave_rect.material, "shader_parameter/size", 0.5, .25 )
	tween.tween_property(shockwave_rect, "modulate:a", 0.0, .2 )
	await tween.finished
	shockwave_rect.visible = false


func _on_body_entered(body: Node2D) -> void:
	var dir = global_position.direction_to(body.global_position)
	if body.has_method("hit"):
		body.hit(damage)
	if body.has_method("knockback"):
		body.knockback(dir, knockback_strength)
	animation_player.play("explode")
	audio_stream_player_2d.play()
	shockwave()
	set_deferred("monitoring", false)
	await audio_stream_player_2d.finished
	queue_free()
