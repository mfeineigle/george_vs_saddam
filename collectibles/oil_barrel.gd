extends Area2D


func _on_body_entered(_body):
	Globals.oil += 1
	queue_free()
