extends CharacterBody2D

@export var speed: int = 250
var sprite: Sprite2D
var get_new_nav: bool = true


func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	

func setup(pos, offset) -> void:
	sprite = $sprites.get_children()[randi() % $sprites.get_children().size()]
	sprite.show()
	position.x = pos.x + offset
	position.y = pos.y
	$NavigationAgent2D.target_position = Globals.player_pos


func _physics_process(_delta):
	if get_new_nav and not $NavigationAgent2D.is_navigation_finished():
		velocity = update_nav()
	var direction = (Globals.player_pos - position).normalized()
	Utils.flip_v_sprite_direction(sprite, direction)
	look_at(Globals.player_pos)
	move_and_slide()
	
	
func _on_nav_timer_timeout() -> void:
	get_new_nav = true
	
func update_nav() -> Vector2:
	$NavTimer.start()
	get_new_nav = false
	$NavigationAgent2D.target_position = Globals.player_pos
	var current_agent_pos = global_position
	var next_path_pos = $NavigationAgent2D.get_next_path_position()
	var new_velocity = (next_path_pos - current_agent_pos).normalized() * speed
	return new_velocity

	
func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
