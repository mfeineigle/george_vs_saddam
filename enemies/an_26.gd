extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

@export var speed: int = 900

var direction: Vector2

func _ready():
	position = Utils.get_spawn_point()
	direction = (Globals.player_pos - position).normalized()
	look_at(Globals.player_pos)
	
func _process(_delta):
	velocity = speed * direction
	move_and_slide()
	
