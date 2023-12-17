extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var hit_sounds: Array[AudioStreamMP3]

var can_fire: bool = true
var destroyed: bool = false


func _ready():
	GameEvents.scud_triggered.connect(_on_scud_triggered)
	$missile.rotation = 0


func _on_scud_triggered(nearest_launch_point):
	if not $HealthComponent.destroyed and self == nearest_launch_point and can_fire:
		$ExhaustExplosion.emitting = true
		$ExhaustExplosion2.emitting = true
		can_fire = false
		$CanFireTimer.start()
		animation_player.play("fire_scud")
		GameEvents.scud_fired.emit(position)

func _on_fire_timer_timeout():
	can_fire = true


func hit(dmg) -> void:
	AudioStreamManager.play(hit_sounds[(randi() % len(hit_sounds))])
	$AnimationPlayer.play("hit")
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		die()

func die() -> void:
	print(name, " died.")
	$DestructionSound.play()
	animation_player.play("die")
	$base.hide()
	$missile.hide()
	$base_destroyed.show()
	for f in $Fires.get_children():
		f.show()
