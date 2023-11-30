extends Area2D

@export var pickup_sound: AudioStreamMP3

var direction: Vector2

func setup(pos, dir) -> void:
	position.x = pos.x - 100
	position.y = pos.y
	direction = dir

func _ready() -> void:
	$CollisionShape2D.disabled = true
	if direction.x < 0:
		$AnimationPlayer.play("falling_from_right") #scale and rotate
	else:
		$AnimationPlayer.play("falling_from_left")
	var fall_down_tween = get_tree().create_tween() #move down
	var target_pos = Vector2(position.x, position.y+250)
	fall_down_tween.tween_property(self, "position", target_pos, 1.0)
	await fall_down_tween.finished
	$CollisionShape2D.disabled = false
	$Thud.play()
	await $Thud.finished

func _on_body_entered(_body) -> void:
	Globals.hp += 5
	AudioStreamManager.play(pickup_sound)
	queue_free()
