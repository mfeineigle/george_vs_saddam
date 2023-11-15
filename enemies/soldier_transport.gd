extends GroundVehicle

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_spawned_soldiers: int
@export var can_spawn_troops: bool
@export var can_spawn_guards: bool

var spawned_soldiers: int = 0
var soldier_types: Array[Signal] = [GameEvents.spawn_guard,
									GameEvents.spawn_troop]


func _on_spawn_soldier_timer_timeout() -> void:
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
	animation_player.play("hit")
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	print(name, " died.")
	$VehicleSprite.hide()
	$DestroyedVehicleSprite.show()
	for f in $Fires.get_children():
		f.look_at(Vector2(1_000_000, f.position.y))
		f.show()
	animation_player.play("die")
