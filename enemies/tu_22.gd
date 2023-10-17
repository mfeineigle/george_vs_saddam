extends CharacterBody2D

@onready var screensize = get_viewport_rect().size
@onready var target = Globals.player_pos

@export var speed: int = 900

var direction: Vector2
var can_bomb: bool = true
var bomb_delay: float = 0.15
var player_near: bool = false


func _ready():
	position = Utils.get_spawn_point()


func _process(_delta):
	if not player_near:
		direction = (Globals.player_pos - position).normalized()
		look_at(Globals.player_pos)
	velocity = speed * direction
	if can_bomb:
		drop_bombs()
		$can_bombTimer.start(bomb_delay)
		can_bomb = false
	move_and_slide()


func drop_bombs():
	GameEvents.tu_22_bomb_dropped.emit(position, rotation)


func _on_bomb_timer_timeout():
	can_bomb = true


func _on_player_near_area_body_entered(_body):
	player_near = true
