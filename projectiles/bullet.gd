class_name Bullet
extends Area2D

@export var speed: int
@export var damage: int
var direction: Vector2

func setup(dir) -> void:
	# TODO cleaner offsetting
#	var offset = Globals.player_pos + (dir.normalized() * 100)

#	position = offset
	position = Globals.player_pos
	if not dir:
		direction = Vector2.RIGHT
	else:
		direction = dir
	look_at(dir)


func _process(_delta) -> void:
	position += direction.normalized() * speed
	
	
func _on_body_entered(body) -> void:
	if not body.name == "George":
		if body.has_method("hit"):
			body.hit(damage)
		queue_free()


#func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("bullet entered area ", area)
	#queue_free()
