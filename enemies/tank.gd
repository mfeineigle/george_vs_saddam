extends GroundVehicle

var shell_scene: PackedScene = preload("res://projectiles/tank_shell.tscn")
@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer

var can_shoot: bool = true
var in_range: bool = false


func _ready():
	direction = Vector2.RIGHT


func _process(_delta) -> void:
	Utils.flip_v_sprite_direction(vehicle_sprite, direction)
	if not $HealthComponent.destroyed:
		velocity = direction * speed
		direction = position.direction_to(Globals.player_pos)
		look_at(Globals.player_pos)
		if not $HealthComponent.destroyed:
			move_and_slide()
		shoot()


func shoot() -> void:
	if can_shoot and in_range and not $HealthComponent.destroyed:
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


func hit(dmg) -> void:
	if not $HealthComponent.destroyed:
		$DeathAnimationPlayer.play("hit")
		$HealthComponent.damage(dmg)
		if $HealthComponent.destroyed:
			$VehicleSprite.hide()
			$DestroyedVehicleSprite.show()
			for f in $Fires.get_children():
				f.show()
			die()

func die() -> void:
	print(name, " died.")
	death_animation_player.play("die")
