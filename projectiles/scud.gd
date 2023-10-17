extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

@export var damage: int = 1
@export var speed = 900

var target: Vector2 = Globals.player_pos
var direction: Vector2 = Vector2.UP
var player_near: bool = false

func _ready():
	$launch_sound.play()


func setup(pos) -> void:
	position.x = pos.x + 85
	position.y = pos.y - 110


func _process(delta):
	velocity = speed * direction * delta
	if at_top_of_screen():
		descend()
	var collider = move_and_collide(velocity)
	if collider or (direction == Vector2.DOWN and position.y >= target.y):
		explode()


func at_top_of_screen() -> bool:
	return position.y < Globals.player_pos.y - screensize.y/2


func descend() -> void:
	$playerNear/CollisionShape2D.set_deferred("disabled", false)
	direction = Vector2.DOWN
	rotation_degrees = -5.8
	$scudSprite.flip_v = true
	$ExhaustParticles.emitting = false
	position.x = target.x


func explode() -> void:
	speed = 0
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()


# called in $AnimationPlayer.play("explode")
func hit() -> void:
	if player_near:
		GameEvents.player_hit.emit(damage) #TODO change to call player.hit()


# test if the scud explosion is close enough to damage player
func _on_player_near_body_entered(body):
	if body in get_tree().get_nodes_in_group("player"):
		player_near = true

func _on_player_near_body_exited(body):
	if body in get_tree().get_nodes_in_group("player"):
		player_near = false
