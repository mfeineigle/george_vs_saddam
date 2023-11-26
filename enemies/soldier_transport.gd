extends GroundVehicle

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_soldier_timer: Timer = $SpawnSoldierTimer

@export var max_soldier_capacity: int
@export var can_spawn_troops: bool
@export var can_spawn_guards: bool

var can_deploy: bool = false
var deployable_soldiers: int
var soldier_types: Array[Signal] = [GameEvents.spawn_guard,
									GameEvents.spawn_troop]


func _ready() -> void:
	deployable_soldiers = max_soldier_capacity


func _on_spawn_soldier_timer_timeout() -> void:
	if deployable_soldiers > 0 and can_deploy:
		deployable_soldiers -= 1
		$AudioStreamPlayer2D.play()
		if can_spawn_guards and can_spawn_troops:
			var spawn_random: Signal = soldier_types[randi() % soldier_types.size()]
			spawn_random.emit($SoldierSpawnPoint.global_position)
		elif can_spawn_guards:
			GameEvents.spawn_guard.emit($SoldierSpawnPoint.global_position)
		elif can_spawn_troops:
			GameEvents.spawn_troop.emit($SoldierSpawnPoint.global_position)
	if deployable_soldiers <= 0:
		$SpawnSoldierTimer.stop()


func hit(dmg) -> void:
	if not $HealthComponent.destroyed:
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


func _on_deploy_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_deploy = true

func _on_deploy_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_deploy = false
