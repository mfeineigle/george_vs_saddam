class_name Soldier extends CharacterBody2D

@export var speed: int = 250
@export var hit_sounds: Array[AudioStreamMP3]
var get_new_nav: bool = true
var in_shotgun_range: bool = false
var in_rifle_range: bool = false
var can_shoot: bool = true
var direction: Vector2
var blood_scene: PackedScene = preload("res://enemies/blood.tscn")
@onready var sprite: Sprite2D = $Sprites.get_children()[randi() % $Sprites.get_children().size()]
@onready var weapon: Area2D = $Weapons.get_children()[randi() % $Weapons.get_children().size()]


func _ready() -> void:
	sprite.show()
	weapon.show()
	call_deferred("nav_setup")


func nav_setup() -> void:
	await get_tree().physics_frame
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos


func setup(pos) -> void:
	position = pos


func _physics_process(_delta):
	if get_new_nav and not $NavigationAgent2D.is_navigation_finished():
		velocity = update_nav()
	direction = (Globals.player_pos - position).normalized()
	Utils.flip_v_sprite_direction(sprite, direction)
	Utils.flip_v_sprite_direction(weapon.sprite_2d, direction)
	if weapon.sprite_2d.flip_v == true:
		weapon.sprite_2d.position = Vector2(14, -83)
		$BulletSpawnPoint.position = Vector2(70, -40)
	else:
		weapon.sprite_2d.position = Vector2(14, 13)
		$BulletSpawnPoint.position = Vector2(70, 40)
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
	var new_velocity = (next_path_pos - current_agent_pos).normalized()
	new_velocity -= avoidance().normalized()
	new_velocity *= speed
	return new_velocity

func avoidance() -> Vector2:
	var avoidance_force: Vector2 = Vector2.ZERO
	for ray in $Rays.get_children():
		if ray.is_colliding(): #if the ray sees another soldier
			#accumulate vector to new_velocity that is opposite the ray's vector
			avoidance_force += ray.get_collision_point() - position
	return avoidance_force


func hit(dmg) -> void:
	$AnimationPlayer.play("hit")
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	print(name, " died.")
	var blood = blood_scene.instantiate()
	Globals.current_level.get_node("Background/Blood").add_child(blood)
	blood.setup(global_position)
	$deathSprite.show()
	sprite.hide()
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()


func shoot() -> void:
	if can_shoot and check_los():
		if weapon.name == "Shotgun" and in_shotgun_range:
			GameEvents.soldier_shot.emit(direction, $BulletSpawnPoint.global_position, weapon)
		elif weapon.name == "Rifle" and in_rifle_range:
			GameEvents.soldier_shot.emit(direction, $BulletSpawnPoint.global_position, weapon)
		can_shoot = false
		$Timers/ShootTimer.start()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func check_los() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, Globals.player_pos)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result and result.collider.name == "George":
		return true
	return false

func _on_shotgun_shoot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_shotgun_range = true

func _on_shotgun_shoot_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_shotgun_range = false


func _on_rifle_shoot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_rifle_range = true


func _on_rifle_shoot_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_rifle_range = false
