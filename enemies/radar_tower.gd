extends StaticBody2D

@export var rotation_speed: float = 1.0
@export var hit_sounds: Array[AudioStreamMP3]
@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer
@onready var collapse_animation_player: AnimationPlayer = $CollapseAnimationPlayer
@onready var health_component: Node2D = $HealthComponent
@onready var rays = get_node("Top/Rays").get_children()
var player_near: bool = false
var radar_retrigger_delay: bool = false


func _ready() -> void:
	$Destroyed/DestroyedTop/DestroyedTopCollision.disabled = true
	$Top.rotation = randi_range(0, 360)


func _process(delta):
	check_radar(delta)


func check_radar(delta) -> void:
	if not health_component.destroyed:
		$Top.rotation += rotation_speed * delta
		if player_near:
			for ray in rays:
				var collider = ray.get_collider()
				if collider in get_tree().get_nodes_in_group("player") and not radar_retrigger_delay:
					radar_retrigger_delay = true
					$RetriggerDelayTimer.start()
					$PingAudio.play()
					Globals.radar_triggers += 1
					GameEvents.spawn_tu_22.emit()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_near = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_near = false


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	if not health_component.destroyed:
		death_animation_player.play("hit")
		health_component.damage(dmg)
		Globals.total_damage_done += dmg
		if health_component.destroyed:
			die()

func die() -> void:
	Globals.radar_kills += 1
	$CollapseAudio.play()
	collapse_animation_player.play("collapse")
	death_animation_player.play("burn")


func _on_retrigger_delay_timer_timeout() -> void:
	radar_retrigger_delay = false
