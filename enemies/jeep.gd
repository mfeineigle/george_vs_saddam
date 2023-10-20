extends GroundVehicle

@onready var offset = $CollisionShape2D.shape.height * -direction.normalized().x

@export var max_spawned_guards: int = 3


var spawned_guards: int = 0


func _ready() -> void:
	direction = Vector2.RIGHT
	if direction == Vector2.LEFT:
		vehicle_sprite.rotation_degrees = 5
	else:
		vehicle_sprite.rotation_degrees = -3


func _process(_delta):
	velocity = direction * speed
	Utils.flip_h_sprite_direction(vehicle_sprite, direction)
	move_and_slide()


func _on_spawn_guard_timer_timeout():
	if spawned_guards < max_spawned_guards:
		spawned_guards += 1
		GameEvents.spawn_guard.emit(position, offset)
