extends CharacterBody2D

@onready var target: Vector2 = Globals.player_pos
@onready var weaponLeft: Area2D = $Guns/LeftGun/Rifle
@onready var weaponRight: Area2D = $Guns/RightGun/Rifle2

@export var speed: int = 750
@export var shoot_delay: float = 0.1

var direction: Vector2
var player_near: bool = false
var can_shoot_left: bool = true
var can_shoot_right: bool = false
var can_target: bool = false


func _ready() -> void:
	position = Utils.get_spawn_point()
	direction = (target - global_position).normalized()


func _process(_delta) -> void:
	if not player_near:
		direction = (Globals.player_pos - position).normalized()
		look_at(Globals.player_pos)
	velocity = speed * direction
	shoot()
	move_and_slide()


func _on_player_near_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true


func shoot() -> void:
	if can_target:
		if can_shoot_left:
			can_shoot_left = false
			$Guns/RightGun/CanShootRightTimer.start(shoot_delay) #refresh the opposite gun
			GameEvents.mi_24_shot.emit(direction, $Guns/LeftGun/BulletSpawnPointLeft.global_position, weaponLeft)
		if can_shoot_right:
			can_shoot_right = false
			$Guns/LeftGun/CanShootLeftTimer.start(shoot_delay) # refresh the opposite gun
			GameEvents.mi_24_shot.emit(direction, $Guns/RightGun/BulletSpawnPointRight.global_position, weaponRight)


func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_target = true

func _on_target_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_target = false


func _on_can_shoot_left_timer_timeout() -> void:
	can_shoot_left = true

func _on_can_shoot_right_timer_timeout() -> void:
	can_shoot_right = true
