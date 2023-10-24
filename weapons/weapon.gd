class_name Weapon extends Node2D


@export var texture: Texture2D
@export var bullet_scene: PackedScene
## How long between shots
@export var shoot_delay: float
var can_shoot: bool = true

func make_bullets(dir, pos) -> Array:
	if can_shoot:
		can_shoot = false
		$CanShootTimer.start(shoot_delay)
		var bullet = bullet_scene.instantiate()
		bullet.setup(dir, pos)
		$AudioStreamShoot.play()
		return [bullet]
	return []
	
	
func _on_body_entered(_body):
	GameEvents.weapon_picked_up.emit(self)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)


func _on_can_shoot_timer_timeout():
	can_shoot = true
