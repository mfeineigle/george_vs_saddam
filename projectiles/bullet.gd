class_name Bullet
extends Area2D

@export var speed: int
@export var damage: int
var direction: Vector2

func setup(dir, pos) -> void:
	position = pos
	if not dir:
		direction = Vector2.RIGHT
	else:
		direction = dir
	look_at(self.global_position + (direction))


func _process(_delta) -> void:
	position += direction.normalized() * speed
	
	
func _on_body_entered(body) -> void:
	if body.has_method("hit"):
		if body.is_in_group("armored"):
			damage -= 1
		body.hit(damage)
	queue_free()
