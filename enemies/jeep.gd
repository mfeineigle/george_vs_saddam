extends GroundVehicle

@onready var offset = $CollisionShape2D.shape.height * -direction.normalized().x
@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer

@export var max_spawned_soldiers: int
var spawned_soldiers: int = 0


func _ready() -> void:
	direction = Vector2.RIGHT
	if direction == Vector2.LEFT:
		vehicle_sprite.rotation_degrees = 5
	else:
		vehicle_sprite.rotation_degrees = -3


func _on_spawn_soldier_timer_timeout():
	if spawned_soldiers < max_spawned_soldiers:
		spawned_soldiers += 1
		GameEvents.spawn_troop.emit(position, offset)
	else:
		$SpawnSoldierTimer.stop()


func hit(dmg) -> void:
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
