extends Bullet


func _on_despawn_timer_timeout():
	queue_free()
