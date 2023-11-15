extends StaticBody2D

@export var rotation_speed: float = 1.0
@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer
@onready var health_component: Node2D = $HealthComponent
@onready var rays = get_node("Top").get_children()
var player_near: bool = false


func _process(delta):
	check_radar(delta)


func check_radar(delta) -> void:
	if player_near and not health_component.destroyed:
		$Top.rotation += rotation_speed * delta
		for ray in rays:
			var collider = ray.get_collider()
			if collider in get_tree().get_nodes_in_group("player"):
				$AudioStreamPlayer2D.play()
				GameEvents.spawn_tu_22.emit()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_near = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_near = false


func hit(dmg) -> void:
	if not health_component.destroyed:
		death_animation_player.play("hit")
		health_component.damage(dmg)
	if health_component.destroyed:
		die()

func die() -> void:
	$DeathAnimation.show()
	death_animation_player.play("die")
