extends StaticBody2D

@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer

@export var total_soldiers: int
@export var follower: GroundVehicle
@export var path: PathFollow2D
@export var hit_sounds: Array[AudioStreamMP3]


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	if not $HealthComponent.destroyed:
		$DeathAnimationPlayer.play("hit")
		$HealthComponent.damage(dmg)
		if $HealthComponent.destroyed:
			die()

func die() -> void:
	total_soldiers = 0
	$Sprite2D.hide()
	$DestroyedSprite.show()
	$DestructionSound.play()
	for f in $Fires.get_children():
		f.show()
	death_animation_player.play("die")
	print(name, " died.")


func _on_delay_deployment_body_entered(body: Node2D) -> void:
	if body == follower:
		follower.spawn_soldier_timer.stop()
		if $HealthComponent.destroyed:
			path.set_process(false)

func _on_delay_deployment_body_exited(body: Node2D) -> void:
	if body == follower:
		follower.spawn_soldier_timer.start()
