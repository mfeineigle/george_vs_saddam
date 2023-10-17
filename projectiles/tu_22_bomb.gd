extends CharacterBody2D

@export var damage: int = 1

var player_near: bool = false

func _ready() -> void:
	$AnimationPlayer.play("drop_bomb")


func setup(pos, rot) -> void:
	position.x = pos.x + randi_range(-30, 30)
	position.y = pos.y + randi_range(-30, 30)
	rotation = rot


func _process(_delta) -> void:
	pass


func explode() -> void:
	$AnimationPlayer.play("explode")
	if player_near:
		hit()
	await $AnimationPlayer.animation_finished
	queue_free()


func hit() -> void:
	GameEvents.player_hit.emit(damage)
	# TODO change to call player.hit()


func _on_area_2d_body_entered(_body):
	player_near = true


func _on_area_2d_body_exited(_body):
	player_near = false
