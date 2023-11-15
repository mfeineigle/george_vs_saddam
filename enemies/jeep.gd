extends GroundVehicle

@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer

@export var max_spawned_soldiers: int
@export var can_spawn_troops: bool
@export var can_spawn_guards: bool

var spawned_soldiers: int = 0
var soldier_types: Array[Signal] = [GameEvents.spawn_guard,
									GameEvents.spawn_troop]

func _process(_delta: float) -> void:
	Utils.rotate_sprite_direction(vehicle_sprite, get_parent().rotation)


func _on_spawn_soldier_timer_timeout():
	if spawned_soldiers < max_spawned_soldiers:
		spawned_soldiers += 1
		$AudioStreamPlayer2D.play()
		if can_spawn_guards and can_spawn_troops:
			var spawn_random: Signal = soldier_types[randi() % soldier_types.size()]
			spawn_random.emit($SoldierSpawnPoint.global_position)
		elif can_spawn_guards:
			GameEvents.spawn_guard.emit($SoldierSpawnPoint.global_position)
		elif can_spawn_troops:
			GameEvents.spawn_troop.emit($SoldierSpawnPoint.global_position)
	else:
		$SpawnSoldierTimer.stop()


func hit(dmg) -> void:
	$DeathAnimationPlayer.play("hit")
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	print(name, " died.")
	$VehicleSprite.hide()
	$DestroyedVehicleSprite.show()
	Utils.rotate_sprite_direction(destroyed_vehicle_sprite, get_parent().rotation)
	for f in $Fires.get_children():
		f.look_at(Vector2(1_000_000, f.position.y))
		f.show()
	death_animation_player.play("die")
