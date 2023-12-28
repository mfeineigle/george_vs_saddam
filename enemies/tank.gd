extends GroundVehicle


@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer
var shell_scene: PackedScene = preload("res://projectiles/tank_shell.tscn")

@export var hit_sounds: Array[AudioStreamMP3]

var can_shoot: bool = true
var in_range: bool = false


func _process(_delta) -> void:
	if not $HealthComponent.destroyed:
		velocity = direction * speed
		direction = $Turret/BulletSpawnPoint.global_position.direction_to(Globals.player_pos)
		$Turret.look_at(Globals.player_pos)
		move_and_slide()
		shoot()


func shoot() -> void:
	if can_shoot and in_range and check_los() and not $HealthComponent.destroyed:
		var shell = shell_scene.instantiate()
		shell.setup(direction, $Turret/BulletSpawnPoint.global_position)
		GameEvents.tank_shot.emit(shell)
		can_shoot = false
		$CanShootTimer.start()
		$FiringSound.play()

func _on_can_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_shoot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true

func _on_shoot_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false

func check_los() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, Globals.player_pos)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result and result.collider.name == "George":
		return true
	return false


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	if not $HealthComponent.destroyed:
		$DeathAnimationPlayer.play("hit")
		$HealthComponent.damage(dmg)
		if $HealthComponent.destroyed:
			die()

func die() -> void:
	Globals.tank_kills += 1
	$DrivingSound.stop()
	$DestructionSound.play()
	$VehicleSprite.hide()
	$Turret.hide()
	$DestroyedVehicleSprite.show()
	$DestroyedTurretSprite.show()
	$DestroyedTurretSprite.look_at(Globals.player_pos)
	Utils.flip_v_sprite_direction(destroyed_vehicle_sprite, direction)
	for f in $Fires.get_children():
		f.look_at(Vector2(1_000_000, f.position.y))
		f.show()
	death_animation_player.play("die")
	print(name, " died.")
