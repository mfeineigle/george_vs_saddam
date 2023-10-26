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
		look_away()
		direction = (Globals.player_pos - position).normalized()
		velocity = speed * -direction
		move_and_slide()
	Utils.rotate_sprite_direction(sprite, rotation)


func look_away() -> void:
		var x = abs(Globals.player_pos.x - position.x)
		if position.x > Globals.player_pos.x:
			x = position.x + x
		else:
			x = position.x - x
		var y = abs(Globals.player_pos.y - position.y)
		if position.y > Globals.player_pos.y:
			y = position.y + y
		else:
			y = position.y - y
		look_at(Vector2(x, y))
		
		
func _on_avoidance_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		run_away = true

func _on_avoidance_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Timers/KeepRunningTimer.start()

func _on_keep_running_timer_timeout() -> void:
	run_away = false
	
	
func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	queue_free()
	
