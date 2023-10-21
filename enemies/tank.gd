extends GroundVehicle

func _ready():
	direction = Vector2.RIGHT

func _process(_delta: float) -> void:
	velocity = direction * speed
	Utils.flip_h_sprite_direction(vehicle_sprite, direction)
	move_and_slide()
