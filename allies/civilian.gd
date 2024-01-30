class_name Civilian extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprites.get_children()[randi() % $Sprites.get_children().size()]
@onready var health_component: Node2D = $HealthComponent

@export var speed: int = 250
@export var hit_sounds: Array[AudioStreamMP3]

var blood_scene: PackedScene = preload("res://enemies/blood.tscn")
var run_away: bool = false
var direction: Vector2
var is_dead: bool = false


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


func look_away(target_pos):
	rotate(get_angle_to(target_pos) + PI);


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	health_component.damage(dmg)
	Globals.total_damage_done += dmg
	if health_component.destroyed:
		die()

func die() -> void:
	is_dead = true
	Globals.civilian_kills += 1
	var blood = blood_scene.instantiate()
	get_parent().add_child(blood)
	#get_owner().get_node("Background/Blood").add_child(blood)
	blood.setup(global_position)
	queue_free()


func _on_run_away_area_inner_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		run_away = true

func _on_run_away_area_outer_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		run_away = false
