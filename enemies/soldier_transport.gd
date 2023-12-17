extends GroundVehicle

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_soldier_timer: Timer = $SpawnSoldierTimer
@onready var health_component: Node2D = $HealthComponent
@onready var soldier_spawn_point: Marker2D = $SoldierSpawnPoint

@export var max_soldier_capacity: int
@export var can_spawn_troops: bool
@export var can_spawn_guards: bool
@export var hit_sounds: Array[AudioStreamMP3]

var can_deploy: bool = false
var deployable_soldiers: int
var soldier_types: Array[Signal] = [GameEvents.spawn_guard,
									GameEvents.spawn_troop]


func _ready() -> void:
	print("transport: ", hit_sounds)
	deployable_soldiers = max_soldier_capacity


func _on_spawn_soldier_timer_timeout() -> void:
	if deployable_soldiers > 0 and can_deploy and not health_component.destroyed:
		deployable_soldiers -= 1
		$AudioStreamPlayer2D.play()
		if can_spawn_guards and can_spawn_troops:
			var spawn_random: Signal = soldier_types[randi() % soldier_types.size()]
			spawn_random.emit(soldier_spawn_point.global_position)
		elif can_spawn_guards:
			GameEvents.spawn_guard.emit(soldier_spawn_point.global_position)
		elif can_spawn_troops:
			GameEvents.spawn_troop.emit(soldier_spawn_point.global_position)
	if deployable_soldiers <= 0:
		spawn_soldier_timer.stop()


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	if not health_component.destroyed:
		animation_player.play("hit")
		health_component.damage(dmg)
		if health_component.destroyed:
			die()

func die() -> void:
	print(name, " died.")
	$DestructionSound.play()
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
