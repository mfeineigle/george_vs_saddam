class_name Soldier extends CharacterBody2D

@export var speed: int = 250
var get_new_nav: bool = true
var player_in_range: bool = false
var can_shoot: bool = true
var direction: Vector2
@onready var sprite: Sprite2D = $Sprites.get_children()[randi() % $Sprites.get_children().size()]
@onready var weapon: Area2D = $Weapons.get_children()[randi() % $Weapons.get_children().size()]


func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	sprite.show()
	weapon.show()
	

func setup(pos, offset) -> void:
	position.x = pos.x + offset
	position.y = pos.y


func _physics_process(_delta):
	if get_new_nav and not $NavigationAgent2D.is_navigation_finished():
		velocity = update_nav()
	direction = (Globals.player_pos - position).normalized()
	Utils.flip_v_sprite_direction(sprite, direction)
	look_at(Globals.player_pos)
	shoot()
	move_and_slide()
		
	
func _on_nav_timer_timeout() -> void:
	get_new_nav = true
	
func update_nav() -> Vector2:
	$Timers/NavTimer.start()
	get_new_nav = false
	$NavigationAgent2D.target_position = Globals.player_pos
	var current_agent_pos = global_position
	var next_path_pos = $NavigationAgent2D.get_next_path_position()
	var new_velocity = (next_path_pos - current_agent_pos).normalized() * speed
	return new_velocity

	
func hit(dmg) -> void:
	$HealthComponent.damage(dmg)


func shoot() -> void:
	if can_shoot:
		if weapon.name == "Shotgun" and player_in_range:
			GameEvents.soldier_shot.emit(direction, position, weapon)
		elif weapon.name == "Rifle":
			GameEvents.soldier_shot.emit(direction, position, weapon)
		can_shoot = false
		$Timers/ShootTimer.start()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_shoot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_shoot_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
