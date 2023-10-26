class_name Civilian extends CharacterBody2D

@export var speed: int = 250
@onready var sprite: Sprite2D = $Sprites.get_children()[randi() % $Sprites.get_children().size()]
var run_away: bool = false
var direction: Vector2


func _ready() -> void:
	sprite.show()
	
	
func _physics_process(_delta) -> void:
	look_at(Globals.player_pos)
	if rotation >= PI or rotation <= -PI:
		rotation = 0
	if run_away:
		look_away(Globals.player_pos)
		direction = (Globals.player_pos - position).normalized()
		velocity = speed * -direction
		move_and_slide()
	Utils.rotate_sprite_direction(sprite, rotation)


func _on_avoidance_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		run_away = true

func _on_avoidance_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Timers/KeepRunningTimer.start()

func _on_keep_running_timer_timeout() -> void:
	run_away = false
	
func look_away(target_pos):
	rotate(get_angle_to(target_pos) + PI);


func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	queue_free()
