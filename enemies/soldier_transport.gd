extends GroundVehicle

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_spawned_soldiers: int
var spawned_soldiers: int = 0


func _on_spawn_soldier_timer_timeout():
	if spawned_soldiers < max_spawned_soldiers:
		spawned_soldiers += 1
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
	#for f in $Fires.get_children():
		#f.show()
	animation_player.play("die")
