extends CharacterBody2D

@onready var paratrooper_scene: PackedScene = preload("res://enemies/paratrooper.tscn")
@onready var screensize = get_viewport_rect().size

@export var speed: int = 900
@export var max_spawned_soldiers: int
@export var can_spawn_troops: bool
@export var can_spawn_guards: bool
## How long the paratrooper tween will play before spawning a soldier
@export var paratrooper_delay: float = 1.5

var spawned_soldiers: int = 0
var can_spawn: bool = false
var soldier_types: Array[Signal] = [GameEvents.spawn_guard,
									GameEvents.spawn_troop]
var direction: Vector2


func _ready() -> void:
	position = Utils.get_spawn_point()
	direction = (Globals.player_pos - position).normalized()
	look_at(Globals.player_pos)


func _process(_delta: float) -> void:
	velocity = speed * direction
	move_and_slide()


func _on_spawn_soldier_timer_timeout() -> void:
	var spawnPoint = $SoldierSpawnPoint.global_position
	if can_spawn and (spawned_soldiers < max_spawned_soldiers):
		spawned_soldiers += 1
		play_paratrooper_animation(spawnPoint, rotation, direction)
		await get_tree().create_timer(paratrooper_delay).timeout
		if can_spawn_guards and can_spawn_troops:
			var spawn_random: Signal = soldier_types[randi() % soldier_types.size()]
			spawn_random.emit(spawnPoint)
		elif can_spawn_guards:
			GameEvents.spawn_guard.emit(spawnPoint)
		elif can_spawn_troops:
			GameEvents.spawn_troop.emit(spawnPoint)
	if spawned_soldiers >= max_spawned_soldiers:
		$SpawnSoldierTimer.stop()

func play_paratrooper_animation(spawnPoint, rot, dir) -> void:
	var paratrooper = paratrooper_scene.instantiate()
	get_node("/root/LevelTestC/Enemies/Soldiers").add_child(paratrooper)
	paratrooper.setup(spawnPoint, rot, dir, paratrooper_delay)


func _on_can_spawn_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_spawn = true
