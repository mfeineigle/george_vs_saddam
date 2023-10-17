extends CharacterBody2D

@onready var offset = $CollisionShape2D.shape.height * -direction.normalized().x

@export var max_spawned_guards: int = 3

var direction: Vector2 = Vector2.LEFT
var speed: int = 500
var spawned_guards: int = 0


func _ready() -> void:
	if direction == Vector2.LEFT:
		$ural_4320.flip_h = true
		$ural_4320.rotation_degrees = 5
	else:
		$ural_4320.flip_h = false
		$ural_4320.rotation_degrees = -3


func _process(_delta):
	velocity = direction * speed
	Utils.flip_h_sprite_direction($ural_4320, direction)
	move_and_slide()


func _on_spawn_guard_timer_timeout():
	if spawned_guards < max_spawned_guards:
		spawned_guards += 1
		GameEvents.spawn_guard.emit(position, offset)
