extends Bullet

var targets: Array = []
@export var splash_damage: int


func _on_explode_timer_timeout():
	_explode_sequence()


func _on_body_entered(body) -> void:
	if not body.name == "George":
		$ExplodeTimer.stop()
		if body.has_method("hit"):
			body.hit(damage) # the initial direct hit, base damage
		_explode_sequence()


func _explode_sequence() -> void:
	set_process(false)
	$AnimationPlayer.play("explode")
	$AudioStreamExplosion.play()
	for target in targets: # deal splash_damage to all targets including
		if target.has_method("hit"): # the direct hit which will take
			target.hit(splash_damage) # a total of (damage + splash_damage)
	$CollisionShape2D.set_deferred("disabled", true)
	$ExplodeArea/ExplodeCollision.set_deferred("disabled", true)
	await $AudioStreamExplosion.finished
	queue_free()


func _on_explode_area_body_entered(body):
	targets.append(body)

func _on_explode_area_body_exited(body):
	targets.erase(body)
