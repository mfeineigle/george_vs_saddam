extends CharacterBody2D

@onready var screensize = get_viewport_rect().size
@onready var target: Vector2 = Globals.player_pos

@export var speed: int = 500

var direction: Vector2
var distance: float
var target_reached: bool = false
var can_drop_dollars: bool = true

func _ready() -> void:
	position = Utils.get_spawn_point()
	direction = (target - global_position).normalized()
	Utils.flip_h_sprite_direction($body, direction)


func _process(_delta):
	distance = position.distance_to(target)
	speed = clamp(distance, 250, 800)
	velocity = speed * direction
	move_and_slide()
	if is_target_reached() and can_drop_dollars:
		can_drop_dollars = false
		GameEvents.pallet_of_dollars_dropped.emit(position, direction)
	
	
func is_target_reached() -> bool:
	if not target_reached and distance < 100:
		target_reached = true
		return true
	return false
	
