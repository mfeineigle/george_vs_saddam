extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var health_component: Node2D = $HealthComponent

@export var hit_sounds: Array[AudioStreamMP3]
@export var is_self_triggered: bool = true

var can_fire: bool = true
var is_player_near: bool = false


func _ready():
	GameEvents.scud_triggered.connect(_on_scud_triggered)
	$missile.rotation = 0


func _on_scud_triggered(nearest_launch_point):
	if not health_component.destroyed and self == nearest_launch_point and can_fire:
		$ExhaustExplosion.emitting = true
		$ExhaustExplosion2.emitting = true
		can_fire = false
		$CanFireTimer.start()
		animation_player.play("fire_scud")
		GameEvents.scud_fired.emit(position)
		Globals.scud_launcher_triggers += 1

func _on_fire_timer_timeout():
	can_fire = true
	if is_player_near == true and is_self_triggered:
		GameEvents.scud_triggered.emit(self)


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	if not health_component.destroyed:
		Globals.total_damage_done += dmg
		animation_player.play("hit")
		health_component.damage(dmg)
		if health_component.destroyed:
			die()

func die() -> void:
	print(name, " died.")
	Globals.scud_launcher_kills += 1
	$DestructionSound.play()
	animation_player.play("die")
	animation_player_2.play("burn")


func _on_self_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_self_triggered:
		is_player_near = true
		GameEvents.scud_triggered.emit(self)

func _on_self_trigger_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_near = false
