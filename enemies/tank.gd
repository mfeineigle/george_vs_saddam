extends GroundVehicle

var shell_scene: PackedScene = preload("res://projectiles/tank_shell.tscn")
@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer

var can_shoot: bool = true
var in_range: bool = false


func _process(_delta) -> void:
	if not $HealthComponent.destroyed:
		velocity = direction * speed
		direction = position.direction_to(Globals.player_pos)
		look_at(Globals.player_pos)
		move_and_slide()
		shoot()


func shoot() -> void:
	if can_shoot and in_range and check_los() and not $HealthComponent.destroyed:
		var shell = shell_scene.instantiate()
		shell.setup(direction, position)
		GameEvents.tank_shot.emit(shell)
		can_shoot = false
		$CanShootTimer.start()

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
	print("los: ", result.collider.name)
	if result.collider.name == "George":
		print("true")
		return true
	return false


func hit(dmg) -> void:
	if not $HealthComponent.destroyed:
		$DeathAnimationPlayer.play("hit")
		$HealthComponent.damage(dmg)
		if $HealthComponent.destroyed:
			die()

func die() -> void:
	$VehicleSprite.hide()
	$DestroyedVehicleSprite.show()
	Utils.flip_v_sprite_direction(destroyed_vehicle_sprite, direction)
	for f in $Fires.get_children():
		Utils.flip_v_sprite_direction(f, direction)
		f.show()
	if $Fires/Fire1.flip_v:
		$Fires/Fire1.position = Vector2(131,52)
		$Fires/Fire2.position = Vector2(10,52)
		$Fires/Fire3.position = Vector2(-110,52)
	death_animation_player.play("die")
	print(name, " died.")
