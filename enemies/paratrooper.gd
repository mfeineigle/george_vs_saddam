extends Sprite2D

@onready var tween = create_tween().set_parallel(true)
	

func setup(pos, rot, dir, delay) -> void:
	position = pos
	rotation = rot - PI/4.0 
	Utils.flip_v_sprite_direction(self, dir)
	if flip_v:
		offset.y = -offset.y
	tween.tween_property(self, "rotation", rotation+PI/4.0, delay)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), delay)
	await tween.finished
	queue_free()
