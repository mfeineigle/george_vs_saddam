extends Weapon


func make_bullets(dir) -> Array:
	if can_shoot:
		can_shoot = false
		$CanShootTimer.start(shoot_delay)
		var bullet_1 = bullet_scene.instantiate()
		var bullet_2 = bullet_scene.instantiate()
		var bullet_3 = bullet_scene.instantiate()
		var bullet_4 = bullet_scene.instantiate()
		var bullet_5 = bullet_scene.instantiate()
		bullet_1.setup(dir.rotated(0.1))
		bullet_2.setup(dir.rotated(0.2))
		bullet_3.setup(dir)
		bullet_4.setup(dir.rotated(-0.1))
		bullet_5.setup(dir.rotated(-0.2))
		$AudioStreamShoot.play()
		return [bullet_1, bullet_2, bullet_3, bullet_4, bullet_5]
	return []
